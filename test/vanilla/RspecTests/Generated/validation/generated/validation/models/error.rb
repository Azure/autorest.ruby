# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module ValidationModule
  module Models
    #
    # Model object.
    #
    #
    class Error
      # @return [Integer]
      attr_accessor :code

      # @return [String]
      attr_accessor :message

      # @return [String]
      attr_accessor :fields


      #
      # Mapper for Error class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Error',
          type: {
            name: 'Composite',
            class_name: 'Error',
            model_properties: {
              code: {
                required: false,
                serialized_name: 'code',
                type: {
                  name: 'Number'
                }
              },
              message: {
                required: false,
                serialized_name: 'message',
                type: {
                  name: 'String'
                }
              },
              fields: {
                required: false,
                serialized_name: 'fields',
                type: {
                  name: 'String'
                }
              }
            }
          }
        }
      end
    end
  end
end
