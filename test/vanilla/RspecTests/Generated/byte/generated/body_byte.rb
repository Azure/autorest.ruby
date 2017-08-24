# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

require 'uri'
require 'cgi'
require 'date'
require 'json'
require 'base64'
require 'erb'
require 'securerandom'
require 'time'
require 'timeliness'
require 'faraday'
require 'faraday-cookie_jar'
require 'concurrent'
require 'ms_rest'
require 'generated/body_byte/module_definition'

module ByteModule
  autoload :Byte,                                               'generated/body_byte/byte.rb'
  autoload :AutoRestSwaggerBATByteService,                      'generated/body_byte/auto_rest_swagger_batbyte_service.rb'

  module Models
    autoload :Error,                                              'generated/body_byte/models/error.rb'
  end
end
