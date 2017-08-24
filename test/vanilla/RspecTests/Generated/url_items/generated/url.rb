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
require 'generated/url/module_definition'

module UrlModule
  autoload :Paths,                                              'generated/url/paths.rb'
  autoload :Queries,                                            'generated/url/queries.rb'
  autoload :PathItems,                                          'generated/url/path_items.rb'
  autoload :AutoRestUrlTestService,                             'generated/url/auto_rest_url_test_service.rb'

  module Models
    autoload :Error,                                              'generated/url/models/error.rb'
    autoload :UriColor,                                           'generated/url/models/uri_color.rb'
  end
end
