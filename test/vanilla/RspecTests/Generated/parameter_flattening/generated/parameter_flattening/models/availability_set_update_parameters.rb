# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module ParameterFlatteningModule
  module Models
    #
    # Model object.
    #
    #
    class AvailabilitySetUpdateParameters
      # @return [Hash{String => String}] A set of tags. A description about the
      # set of tags.
      attr_accessor :tags


      #
      # Mapper for AvailabilitySetUpdateParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'AvailabilitySetUpdateParameters',
          type: {
            name: 'Composite',
            class_name: 'AvailabilitySetUpdateParameters',
            model_properties: {
              tags: {
                required: true,
                serialized_name: 'tags',
                type: {
                  name: 'Dictionary',
                  value: {
                      required: false,
                      serialized_name: 'StringElementType',
                      type: {
                        name: 'String'
                      }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end
