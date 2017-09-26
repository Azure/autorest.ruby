﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.Model;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using System.Text.RegularExpressions;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// The model for Azure model template.
    /// </summary>
    public class CompositeTypeRba : CompositeTypeRb
    {
        public static readonly Regex resourceOrSubResourceRegEx = new Regex(@"^(RESOURCE|SUBRESOURCE)$", RegexOptions.IgnoreCase);
        private static readonly Regex subResourceRegEx = new Regex(@"^(ID)$", RegexOptions.IgnoreCase);
        private static readonly Regex resourceRegEx = new Regex(@"^(ID|NAME|TYPE|LOCATION|TAGS)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// Initializes a new instance of the AzureModelTemplateModel class.
        /// </summary>
        /// <param name="source">The object to create model from.</param>
        /// <param name="allTypes">The list of all model types; Used to implement polymorphism.</param>
        /// <summary>
        /// Initializes a new instance of the ModelTemplateModel class.
        /// </summary>
        protected CompositeTypeRba()
        {
        }

        protected CompositeTypeRba(string name): base(name)
        {

        }

        /// <summary>
        /// Returns code for declaring inheritance.
        /// </summary>
        /// <returns>Code for declaring inheritance.</returns>
        public override string GetBaseTypeName()
        {
            if (this.BaseModelType != null)
            {
                string typeName = this.BaseModelType.Name;

                if (this.BaseModelType.Extensions.ContainsKey(AzureExtensions.ExternalExtension) ||
                    this.BaseModelType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension))
                {
                    if (resourceOrSubResourceRegEx.IsMatch(typeName) || IsResourceModelMatchingStandardDefinition(this))
                    {
                        typeName = "MsRestAzure::" + typeName;
                    }
                }

                return " < " + typeName;
            }
            else if (resourceOrSubResourceRegEx.IsMatch(this.Name))
            {
                return " < " + "MsRestAzure::" + this.Name;
            }

            return string.Empty;
        }

        /// <summary>
        /// Checks if the provided definition of model matches the standard definition of 'Resource'/'SubResource',
        /// as defined in MsRestAzure.
        /// </summary>
        /// <param name="model">CompositeType model to be validated.</param>
        /// <returns><c>true</c> if model matches standard name and definition of Resource or SubResource, <c>false</c> otherwise.</returns>
        public static bool IsResourceModelMatchingStandardDefinition(CompositeType model)
        {
            string modelName = model.Name.ToString();
            if (!resourceOrSubResourceRegEx.IsMatch(modelName))
            {
                return false;
            }

            if (model.Properties.All(property => subResourceRegEx.IsMatch(property.Name.ToString())) || 
                model.Properties.All(property => resourceRegEx.IsMatch(property.Name.ToString())))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Determines if the accessor needs to be generated. For Resource/SubResource models, accessors are generated only
        /// for properties that are not in the standard definition, as defined in MsRestAzure.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="propertyName"></param>
        /// <returns></returns>
        public static bool NeedsAccessor(CompositeType model, string propertyName)
        {
            string modelName = model.Name.ToString();
            if((modelName.EqualsIgnoreCase("SubResource") && subResourceRegEx.IsMatch(propertyName)) ||
               (modelName.EqualsIgnoreCase("Resource") && resourceRegEx.IsMatch(propertyName)))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public override IEnumerable<string> Includes
        {
            get { yield return "MsRestAzure"; }
        }

        public override IEnumerable<string> ClassNamespaces
        {
            get { yield return "MsRestAzure"; }
        }
    }
}