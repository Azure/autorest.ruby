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
require 'generated/body_datetime_rfc1123/module_definition'

module DatetimeRfc1123Module
  autoload :Datetimerfc1123,                                    'generated/body_datetime_rfc1123/datetimerfc1123.rb'
  autoload :AutoRestRFC1123DateTimeTestService,                 'generated/body_datetime_rfc1123/auto_rest_rfc1123date_time_test_service.rb'

  module Models
    autoload :Error,                                              'generated/body_datetime_rfc1123/models/error.rb'
  end
end
