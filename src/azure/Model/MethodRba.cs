﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.NetworkInformation;
using AutoRest.Core.Logging;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using AutoRest.Ruby.Model;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;
using IndentedStringBuilder = AutoRest.Core.Utilities.IndentedStringBuilder;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// The model object for Azure methods.
    /// </summary>
    public class MethodRba : MethodRb
    {

        public string ClientRequestIdString => AzureExtensions.GetClientRequestIdString(this);

        public string RequestIdString => AzureExtensions.GetRequestIdString(this);

        public string CorrelationRequestIdString => AzureExtensions.GetCorrelationRequestIdString(this);

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation => Extensions.ContainsKey(AzureExtensions.LongRunningExtension);

        /// <summary>
        /// Returns true if method has x-ms-pageable extension.
        /// </summary>
        public bool IsPageable => Extensions.ContainsKey(AzureExtensions.PageableExtension);

        /// <summary>
        /// Returns Ruby code as string which sets `next_method` property of the page with the respective next paging method
        /// and performs parameter re-assignment when required (ex. parameter grouping cases)
        /// </summary>
        public string AssignNextMethodToPage()
        {
            string nextMethodName;
            Method nextMethod = null;
            PageableExtension pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());

            // When pageable extension have operation name
            if (pageableExtension != null && !string.IsNullOrWhiteSpace(pageableExtension.OperationName))
            {
                nextMethod = MethodGroup.Methods.FirstOrDefault(m =>pageableExtension.OperationName.EqualsIgnoreCase(m.SerializedName));
                nextMethodName = nextMethod.Name;
            }
            // When pageable extension does not have operation name
            else
            {
                nextMethodName = (string)Extensions["nextMethodName"];
                nextMethod = MethodGroup.Methods.FirstOrDefault(m => m.Name == nextMethodName);
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");
            
            // As there is no distinguishable property in next link parameter, we'll check to see whether any parameter contains "next" in the parameter name
            Parameter nextLinkParameter = nextMethod.Parameters.Where(p => ((string)p.Name).IndexOf("next", StringComparison.OrdinalIgnoreCase) >= 0).FirstOrDefault();
            builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "page.next_method = Proc.new do |{0}|", nextLinkParameter.Name));

            // In case of parmeter grouping, next methods parameter needs to be mapped with the origin methods parameter
            var origName = Singleton<CodeNamerRb>.Instance.UnderscoreCase(Name.RawValue);
            IEnumerable<Parameter> origMethodGroupedParameters = Parameters.Where(p => p.Name.Contains(origName));
            if (origMethodGroupedParameters.Any())
            {
                builder.Indent();
                foreach (Parameter param in nextMethod.Parameters)
                {
                    if (param.Name.Contains(nextMethod.Name) && (((string)param.Name.RawValue).Length > ((string)nextMethod.Name).Length)) //parameter that contains the method name + postfix, it's a grouped param
                    {
                        //assigning grouped parameter passed to the lazy method, to the parameter used in the invocation to the next method
                        string argumentName = ((string)param.Name).Replace(nextMethodName, origName);
                        builder.AppendLine(string.Format(CultureInfo.InvariantCulture, "{0} = {1}", param.Name, argumentName));
                    }
                }
                builder.Outdent();
            }

            // Create AzureMethodTemplateModel from nextMethod to determine nextMethod's MethodParameterInvocation signature
            MethodRba nextMethodTemplateModel = New<MethodRba>().LoadFrom(nextMethod);
            builder.Indent().AppendLine(string.Format(CultureInfo.InvariantCulture, "{0}_async({1})", nextMethodName, nextMethodTemplateModel.MethodParameterInvocation));
            builder.Outdent().Append(String.Format(CultureInfo.InvariantCulture, "end"));

            return builder.ToString();
        }

        /// <summary>
        /// Returns generated response or body of the auto-paginated method.
        /// </summary>
        public override string ResponseGeneration()
        {

            IndentedStringBuilder builder = new IndentedStringBuilder();
            if (ReturnType.Body != null)
            {
                if (ReturnType.Body is CompositeType)
                {
                    CompositeType compositeType = (CompositeType)ReturnType.Body;
                    if (compositeType.Extensions.ContainsKey(AzureExtensions.PageableExtension) && this.Extensions.ContainsKey("nextMethodName"))
                    {
                        bool isNextLinkMethod = this.Extensions.ContainsKey("nextLinkMethod") && (bool)this.Extensions["nextLinkMethod"];
                        bool isPageable = (bool)compositeType.Extensions[AzureExtensions.PageableExtension];
                        if (isPageable && !isNextLinkMethod)
                        {
                            builder.AppendLine("first_page = {0}_as_lazy({1})", Name, MethodParameterInvocation);
                            builder.AppendLine("first_page.get_all_items");
                            return builder.ToString();
                        }
                    }
                }
            }
            return base.ResponseGeneration();

        }

        /// <summary>
        /// Gets the Get method model.
        /// </summary>
        public MethodRba GetMethod
        {
            get
            {
                var getMethod = MethodGroup.Methods.FirstOrDefault(m => m.Url == Url && m.HttpMethod == HttpMethod.Get );
                if (getMethod == null)
                {
                    throw new InvalidOperationException("Long running operations for CreateOrUpdate require a GET operation under the same path and same operation group.");
                }

                return New<MethodRba>().LoadFrom(getMethod);
            }
        }

        /// <summary>
        /// Generates Ruby code in form of string for deserializing polling response.
        /// </summary>
        /// <param name="variableName">Variable name which keeps the response.</param>
        /// <param name="type">Type of response.</param>
        /// <returns>Ruby code in form of string for deserializing polling response.</returns>
        public string DeserializePollingResponse(string variableName, IModelType type)
        {
            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = GetDeserializationString(type, variableName, variableName);
            return builder.AppendLine(serializationLogic).ToString();
        }

        public string GetLongRunningOperationResponse(string clientReference)
        {
            var builder = new IndentedStringBuilder("  ");
            string lroOption = GetLROOptions();
            if (lroOption.Length == 0)
            {
                return builder.AppendLine("{0}.get_long_running_operation_result(response, deserialize_method)", clientReference).ToString();
            }
            return builder.AppendLine("{0}.get_long_running_operation_result(response, deserialize_method, {1})", clientReference, lroOption).ToString();
        }

        public string GetLROOptions()
        {
            if(this.HttpMethod != HttpMethod.Post || this.ReturnType == null)
            {
                return "";
            }

            switch (this.LongRunningFinalState)
            {
                case FinalStateVia.Location:
                    return "FinalStateVia::LOCATION";
                case FinalStateVia.AzureAsyncOperation:
                    return "FinalStateVia::AZURE_ASYNC_OPERATION";
                case FinalStateVia.OriginalUri:
                    return "FinalStateVia::ORIGINAL_URI";
                default:
                    break;
            }

            return "";
        }

        /// <summary>
        /// Gets the logic required to preprocess response body when required.
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                var sb = new IndentedStringBuilder();

                if (this.HttpMethod == HttpMethod.Head && this.ReturnType.Body != null)
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    sb.AppendLine("result.body = (status_code == {0})", (int)code);
                }

                sb.AppendLine(
                    "result.request_id = http_response['{0}'] unless http_response['{0}'].nil?", this.RequestIdString);
                sb.AppendLine(
                    "result.correlation_request_id = http_response['{0}'] unless http_response['{0}'].nil?", this.CorrelationRequestIdString);
                sb.AppendLine(
                    "result.client_request_id = http_response['{0}'] unless http_response['{0}'].nil?", this.ClientRequestIdString);

                sb.AppendLine(base.InitializeResponseBody);

                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets the list of namespaces where we look for classes that need to
        /// be instantiated dynamically due to polymorphism.
        /// </summary>
        public override IEnumerable<string> ClassNamespaces
        {
            get { yield return "MsRestAzure"; }
        }

        /// <summary>
        /// Gets the expression for default header setting.
        /// </summary>
        public override string SetDefaultHeaders
        {
            get
            {
                IndentedStringBuilder sb = new IndentedStringBuilder();
                sb.AppendLine("request_headers['{0}'] = SecureRandom.uuid", this.ClientRequestIdString)
                  .AppendLine(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets AzureOperationResponse generic type declaration.
        /// </summary>
        public override string OperationResponseReturnTypeString
        {
            get
            {
                return "MsRestAzure::AzureOperationResponse";
            }
        }

        /// <summary>
        /// Gets the list of middelwares required for HTTP requests.
        /// </summary>
        public override IList<string> FaradayMiddlewares
        {
            get
            {
                return new List<string>()
                {
                    "[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]",
                    "[:cookie_jar]"
                };
            }
        }

        /// <summary>
        /// Gets the type for operation exception.
        /// </summary>
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    return "MsRestAzure::AzureOperationError";
                }

                return base.OperationExceptionTypeString;
            }
        }

        /// <summary>
        /// Gets the type for operation result.
        /// </summary>
        public override string OperationReturnTypeString
        {
            get
            {
                if (Extensions.ContainsKey("nextMethodName") && (!Extensions.ContainsKey(AzureExtensions.PageableExtension) ||
                    (Extensions.ContainsKey(AzureExtensions.PageableExtension) && Extensions.ContainsKey(AzureExtensions.LongRunningExtension))))
                {
                    try
                    {
                        SequenceType sequenceType = ((CompositeType)ReturnType.Body).Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as SequenceType;
                        return string.Format(CultureInfo.InvariantCulture, "Array<{0}>", sequenceType.ElementType.Name);
                    }
                    catch (NullReferenceException nr)
                    {
                        throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "No collection type exists in pageable operation return type: {0}", nr.StackTrace));
                    }
                }
                return base.OperationReturnTypeString;
            }
        }
    }
}