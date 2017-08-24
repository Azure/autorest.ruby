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
    # The product documentation.
    #
    class Product
      # @return [Array<String>] Non required array of unique items from 0 to 6
      # elements.
      attr_accessor :display_names

      # @return [Integer] Non required int betwen 0 and 100 exclusive.
      attr_accessor :capacity

      # @return [String] Image URL representing the product.
      attr_accessor :image

      # @return [ChildProduct]
      attr_accessor :child

      # @return [ConstantProduct] . Default value: {} .
      attr_accessor :const_child

      # @return [Integer] Constant int. Default value: 0 .
      attr_accessor :const_int

      # @return [String] Constant string. Default value: 'constant' .
      attr_accessor :const_string

      # @return [EnumConst] Constant string as Enum. Possible values include:
      # 'constant_string_as_enum'
      attr_accessor :const_string_as_enum


      #
      # Mapper for Product class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Product',
          type: {
            name: 'Composite',
            class_name: 'Product',
            model_properties: {
              display_names: {
                required: false,
                serialized_name: 'display_names',
                constraints: {
                  MaxItems: 6,
                  MinItems: 0,
                  UniqueItems: true
                },
                type: {
                  name: 'Sequence',
                  element: {
                      required: false,
                      serialized_name: 'StringElementType',
                      type: {
                        name: 'String'
                      }
                  }
                }
              },
              capacity: {
                required: false,
                serialized_name: 'capacity',
                constraints: {
                  ExclusiveMaximum: 100,
                  ExclusiveMinimum: 0
                },
                type: {
                  name: 'Number'
                }
              },
              image: {
                required: false,
                serialized_name: 'image',
                constraints: {
                  Pattern: 'http://\w+'
                },
                type: {
                  name: 'String'
                }
              },
              child: {
                required: true,
                serialized_name: 'child',
                default_value: {},
                type: {
                  name: 'Composite',
                  class_name: 'ChildProduct'
                }
              },
              const_child: {
                required: true,
                is_constant: true,
                serialized_name: 'constChild',
                default_value: {},
                type: {
                  name: 'Composite',
                  class_name: 'ConstantProduct'
                }
              },
              const_int: {
                required: true,
                is_constant: true,
                serialized_name: 'constInt',
                default_value: 0,
                type: {
                  name: 'Number'
                }
              },
              const_string: {
                required: true,
                is_constant: true,
                serialized_name: 'constString',
                default_value: 'constant',
                type: {
                  name: 'String'
                }
              },
              const_string_as_enum: {
                required: false,
                serialized_name: 'constStringAsEnum',
                type: {
                  name: 'Enum',
                  module: 'EnumConst'
                }
              }
            }
          }
        }
      end
    end
  end
end
