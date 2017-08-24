# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module ComplexModule
  module Models
    #
    # Model object.
    #
    #
    class Datetimerfc1123Wrapper
      # @return [DateTime]
      attr_accessor :field

      # @return [DateTime]
      attr_accessor :now


      #
      # Mapper for Datetimerfc1123Wrapper class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'datetimerfc1123-wrapper',
          type: {
            name: 'Composite',
            class_name: 'Datetimerfc1123Wrapper',
            model_properties: {
              field: {
                required: false,
                serialized_name: 'field',
                type: {
                  name: 'DateTimeRfc1123'
                }
              },
              now: {
                required: false,
                serialized_name: 'now',
                type: {
                  name: 'DateTimeRfc1123'
                }
              }
            }
          }
        }
      end
    end
  end
end
