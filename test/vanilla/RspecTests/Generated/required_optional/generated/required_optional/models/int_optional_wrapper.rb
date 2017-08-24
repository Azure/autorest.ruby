# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module RequiredOptionalModule
  module Models
    #
    # Model object.
    #
    #
    class IntOptionalWrapper
      # @return [Integer]
      attr_accessor :value


      #
      # Mapper for IntOptionalWrapper class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'int-optional-wrapper',
          type: {
            name: 'Composite',
            class_name: 'IntOptionalWrapper',
            model_properties: {
              value: {
                required: false,
                serialized_name: 'value',
                type: {
                  name: 'Number'
                }
              }
            }
          }
        }
      end
    end
  end
end
