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
    class DurationWrapper
      # @return [Duration]
      attr_accessor :field


      #
      # Mapper for DurationWrapper class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'duration-wrapper',
          type: {
            name: 'Composite',
            class_name: 'DurationWrapper',
            model_properties: {
              field: {
                required: false,
                serialized_name: 'field',
                type: {
                  name: 'TimeSpan'
                }
              }
            }
          }
        }
      end
    end
  end
end
