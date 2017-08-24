# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module AzureSpecialPropertiesModule
  #
  # Test Infrastructure for AutoRest
  #
  class ApiVersionLocal
    include MsRestAzure

    #
    # Creates and initializes a new instance of the ApiVersionLocal class.
    # @param client service class for accessing basic functionality.
    #
    def initialize(client)
      @client = client
    end

    # @return [AutoRestAzureSpecialParametersTestClient] reference to the AutoRestAzureSpecialParametersTestClient
    attr_reader :client

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def get_method_local_valid(custom_headers = nil)
      response = get_method_local_valid_async(custom_headers).value!
      nil
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRestAzure::AzureOperationResponse] HTTP response information.
    #
    def get_method_local_valid_with_http_info(custom_headers = nil)
      get_method_local_valid_async(custom_headers).value!
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_method_local_valid_async(custom_headers = nil)
      api_version = '2.0'


      request_headers = {}

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'azurespecials/apiVersion/method/string/none/query/local/2.0'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'api-version' => api_version},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # null to succeed
    #
    # @param api_version [String] This should appear as a method parameter, use
    # value null, this should result in no serialized parameter
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def get_method_local_null(api_version = nil, custom_headers = nil)
      response = get_method_local_null_async(api_version, custom_headers).value!
      nil
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # null to succeed
    #
    # @param api_version [String] This should appear as a method parameter, use
    # value null, this should result in no serialized parameter
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRestAzure::AzureOperationResponse] HTTP response information.
    #
    def get_method_local_null_with_http_info(api_version = nil, custom_headers = nil)
      get_method_local_null_async(api_version, custom_headers).value!
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # null to succeed
    #
    # @param api_version [String] This should appear as a method parameter, use
    # value null, this should result in no serialized parameter
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_method_local_null_async(api_version = nil, custom_headers = nil)


      request_headers = {}

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'azurespecials/apiVersion/method/string/none/query/local/null'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'api-version' => api_version},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def get_path_local_valid(custom_headers = nil)
      response = get_path_local_valid_async(custom_headers).value!
      nil
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRestAzure::AzureOperationResponse] HTTP response information.
    #
    def get_path_local_valid_with_http_info(custom_headers = nil)
      get_path_local_valid_async(custom_headers).value!
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_path_local_valid_async(custom_headers = nil)
      api_version = '2.0'


      request_headers = {}

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'azurespecials/apiVersion/path/string/none/query/local/2.0'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'api-version' => api_version},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?

        result
      end

      promise.execute
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    #
    def get_swagger_local_valid(custom_headers = nil)
      response = get_swagger_local_valid_async(custom_headers).value!
      nil
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param custom_headers [Hash{String => String}] A hash of custom headers that
    # will be added to the HTTP request.
    #
    # @return [MsRestAzure::AzureOperationResponse] HTTP response information.
    #
    def get_swagger_local_valid_with_http_info(custom_headers = nil)
      get_swagger_local_valid_async(custom_headers).value!
    end

    #
    # Get method with api-version modeled in the method.  pass in api-version =
    # '2.0' to succeed
    #
    # @param [Hash{String => String}] A hash of custom headers that will be added
    # to the HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def get_swagger_local_valid_async(custom_headers = nil)
      api_version = '2.0'


      request_headers = {}

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?
      path_template = 'azurespecials/apiVersion/swagger/string/none/query/local/2.0'

      request_url = @base_url || @client.base_url

      options = {
          middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]],
          query_params: {'api-version' => api_version},
          headers: request_headers.merge(custom_headers || {}),
          base_url: request_url
      }
      promise = @client.make_request_async(:get, path_template, options)

      promise = promise.then do |result|
        http_response = result.response
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(result.request, http_response, error_model)
        end

        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?

        result
      end

      promise.execute
    end

  end
end
