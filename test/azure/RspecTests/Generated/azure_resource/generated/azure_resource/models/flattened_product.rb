# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module AzureResourceModule
  module Models
    #
    # Model object.
    #
    #
    class FlattenedProduct < MsRestAzure::Resource

      include MsRestAzure

      include MsRest::JSONable
      # @return [String]
      attr_accessor :pname

      # @return [Integer]
      attr_accessor :lsize

      # @return [String]
      attr_accessor :provisioning_state


      #
      # Mapper for FlattenedProduct class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'FlattenedProduct',
          type: {
            name: 'Composite',
            class_name: 'FlattenedProduct',
            model_properties: {
              id: {
                required: false,
                read_only: true,
                serialized_name: 'id',
                type: {
                  name: 'String'
                }
              },
              type: {
                required: false,
                read_only: true,
                serialized_name: 'type',
                type: {
                  name: 'String'
                }
              },
              tags: {
                required: false,
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
              },
              location: {
                required: false,
                serialized_name: 'location',
                type: {
                  name: 'String'
                }
              },
              name: {
                required: false,
                read_only: true,
                serialized_name: 'name',
                type: {
                  name: 'String'
                }
              },
              pname: {
                required: false,
                serialized_name: 'properties.pname',
                type: {
                  name: 'String'
                }
              },
              lsize: {
                required: false,
                serialized_name: 'properties.lsize',
                type: {
                  name: 'Number'
                }
              },
              provisioning_state: {
                required: false,
                serialized_name: 'properties.provisioningState',
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
