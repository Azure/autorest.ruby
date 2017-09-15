﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Ruby.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby
{
    using System.Collections.Generic;
    using System.Reflection;
    /// <summary>
    /// Keeps a few aux method used across all templates/models.
    /// </summary>
    public static class ClientModelExtensions
    {
        /// <summary>
        /// Determines if a type can be assigned the value null.
        /// </summary>
        /// <param name="type">The type to check.</param>
        /// <returns>True if null can be assigned, otherwise false.</returns>
        public static bool IsNullable(this IModelType type)
        {
            return true;
        }

        /// <summary>
        /// Simple conversion of the type to string.
        /// </summary>
        /// <param name="type">The type to convert</param>
        /// <param name="reference">a reference to an instance of the type</param>
        /// <returns></returns>
        public static string ToString(this IModelType type, string reference)
        {
            var known = type as PrimaryType;
            string result = $"{reference}.to_s";
            if (known != null)
            {
                if (known.KnownPrimaryType == KnownPrimaryType.String)
                {
                    result = reference;
                }
                else if (known.KnownPrimaryType == KnownPrimaryType.DateTime)
                {
                    result = $"{reference}.new_offset(0).strftime('%FT%TZ')";
                }
                else if (known.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                {
                    result = $"{reference}.strftime('%a, %d %b %Y %H:%M:%S GMT')";
                }
            }

            return result;
        }

        /// <summary>
        /// Internal method for generating Yard-compatible representation of given type.
        /// </summary>
        /// <param name="type">The type doc needs to be generated for.</param>
        /// <returns>Doc in form of string.</returns>
        private static string PrepareTypeForDocRecursively(IModelType type)
        {
            var sequenceType = type as SequenceType;
            var compositeType = type as CompositeType;
            var enumType = type as EnumType;
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;

            if (primaryType != null)
            {
                if (primaryType.KnownPrimaryType == KnownPrimaryType.String)
                {
                    return "String";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.Int || primaryType.KnownPrimaryType == KnownPrimaryType.Long)
                {
                    return "Integer";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.Boolean)
                {
                    return "Boolean";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.Double)
                {
                    return "Float";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.Date)
                {
                    return "Date";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.DateTime)
                {
                    return "DateTime";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                {
                    return "DateTime";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray)
                {
                    return "Array<Integer>";
                }

                if (primaryType.KnownPrimaryType == KnownPrimaryType.TimeSpan)
                {
                    return "Duration"; //TODO: Is this a real Ruby type...?
                }
            }

            if (compositeType != null)
            {
                return compositeType.Name;
            }

            if (enumType != null)
            {
                return ((EnumTypeRb)enumType).ModuleName;
            }

            if (sequenceType != null)
            {
                string internalString = PrepareTypeForDocRecursively(sequenceType.ElementType);

                if (!string.IsNullOrEmpty(internalString))
                {
                    return $"Array<{internalString}>";
                }

                return string.Empty;
            }

            if (dictionaryType != null)
            {
                string internalString = PrepareTypeForDocRecursively(dictionaryType.ValueType);

                if (!string.IsNullOrEmpty(internalString))
                {
                    return $"Hash{{String => {internalString}}}";
                }

                return string.Empty;
            }

            return string.Empty;
        }

        /// <summary>
        /// Return the separator associated with a given collectionFormat.
        /// </summary>
        /// <param name="format">The collection format.</param>
        /// <returns>The separator.</returns>
        private static string GetSeparator(this CollectionFormat format)
        {
            switch (format)
            {
                case CollectionFormat.Csv:
                    return ",";
                case CollectionFormat.Pipes:
                    return "|";
                case CollectionFormat.Ssv:
                    return " ";
                case CollectionFormat.Tsv:
                    return "\t";
                default:
                    throw new NotSupportedException($"Collection format {format} is not supported.");
            }
        }

        /// <summary>
        /// Format the value of a sequence given the modeled element format.
        /// </summary>
        /// <param name="parameter">The parameter to format.</param>
        /// <returns>A reference to the formatted parameter value.</returns>
        public static string GetFormattedReferenceValue(this Parameter parameter)
        {
            SequenceType sequence = parameter.ModelType as SequenceType;
            if (sequence == null)
            {
                return parameter.Name;
            }

            return string.Format("{0}.nil? ? nil : {0}.join('{1}')", parameter.Name, parameter.CollectionFormat.GetSeparator());
        }

        /// <summary>
        /// Generates Yard-compatible representation of given type.
        /// </summary>
        /// <param name="type">The type doc needs to be generated for.</param>
        /// <returns>Doc in form of string.</returns>
        public static string GetYardDocumentation(this IModelType type)
        {
            string typeForDoc = PrepareTypeForDocRecursively(type);

            if (string.IsNullOrEmpty(typeForDoc))
            {
                return string.Empty;
            }

            return $"[{typeForDoc}] ";
        }

        /// <summary>
        /// Generate code to perform required validation on a type.
        /// </summary>
        /// <param name="type">The type to validate.</param>
        /// <param name="scope">A scope provider for generating variable names as necessary.</param>
        /// <param name="valueReference">A reference to the value being validated.</param>
        /// <returns>The code to validate the reference of the given type.</returns>
        public static string ValidateType(this IModelType type, IIdentifier scope, string valueReference)
        {
            CompositeType model = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;

            if (model != null && model.Properties.Any())
            {
                return string.Format("{0}.validate unless {0}.nil?", valueReference);
            }

            if (sequence != null || dictionary != null)
            {
                return string.Format("{0}.each{{ |e| e.validate if e.respond_to?(:validate) }} unless {0}.nil?" + Environment.NewLine, valueReference);
            }

            return null;
        }

        /// <summary>
        /// Determine whether a model should be serializable.
        /// </summary>
        /// <param name="type">The type to check.</param>
        public static bool IsSerializable(this IModelType type)
        {
            return !type.IsPrimaryType(KnownPrimaryType.Object);
        }

        /// <summary>
        /// Determines whether one composite type derives directly or indirectly from another.
        /// </summary>
        /// <param name="type">Type to test.</param>
        /// <param name="possibleAncestorType">Type that may be an ancestor of this type.</param>
        /// <returns>true if the type is an ancestor, false otherwise.</returns>
        public static bool DerivesFrom(this CompositeType type, CompositeType possibleAncestorType)
        {
            return
                type.BaseModelType != null &&
                (type.BaseModelType.Equals(possibleAncestorType) ||
                 type.BaseModelType.DerivesFrom(possibleAncestorType));
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="type"/>.
        /// </summary>
        /// <param name="type">Type for which mapper being generated.</param>
        /// <param name="serializedName">Serialized name to be used.</param>
        /// <param name="parameter">Parameter of the composite type to construct the parameter constraints.</param>
        /// <param name="expandComposite">Expand composite type if <c>true</c> otherwise specify class_name in the mapper.</param>
        /// <returns>Mapper for the <paramref name="type"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// One of the example of the mapper is 
        /// {
        ///   required: false,
        ///   serialized_name: 'Fish',
        ///   type: {
        ///     name: 'Composite',
        ///     polymorphic_discriminator: 'fishtype',
        ///     uber_parent: 'Fish',
        ///     class_name: 'Fish',
        ///     model_properties: {
        ///       species: {
        ///         required: false,
        ///         serialized_name: 'species',
        ///         type: {
        ///           name: 'String'
        ///         }
        ///       },
        ///       length: {
        ///         required: true,
        ///         serialized_name: 'length',
        ///         type: {
        ///           name: 'Double'
        ///         }
        ///       },
        ///       siblings: {
        ///         required: false,
        ///         serialized_name: 'siblings',
        ///         type: {
        ///           name: 'Sequence',
        ///           element: {
        ///               required: false,
        ///               serialized_name: 'FishElementType',
        ///               type: {
        ///                 name: 'Composite',
        ///                 polymorphic_discriminator: 'fishtype',
        ///                 uber_parent: 'Fish',
        ///                 class_name: 'Fish'
        ///               }
        ///           }
        ///         }
        ///       }
        ///     }
        ///   }
        /// }
        /// </example>
        public static string ConstructMapper(this IModelType type, string serializedName, IVariable parameter, bool expandComposite)
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            var builder = new IndentedStringBuilder("  ");

            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                primary = New<PrimaryType>(KnownPrimaryType.String);
            }
            builder.AppendLine("").Indent();

            builder.AppendLine(type.AddMetaData(serializedName, parameter));

            if (primary != null)
            {
                builder.AppendLine(primary.ContructMapperForPrimaryType());
            }
            else if (enumType != null && enumType.Name != null)
            {
                builder.AppendLine(((EnumTypeRb)enumType).ContructMapperForEnumType());
            }
            else if (sequence != null)
            {
                builder.AppendLine(sequence.ContructMapperForSequenceType());
            }
            else if (dictionary != null)
            {
                builder.AppendLine(dictionary.ContructMapperForDictionaryType());
            }
            else if (composite != null)
            {
                builder.AppendLine(composite.ContructMapperForCompositeType(expandComposite));
            }
            else
            {
                throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture, "{0} is not a supported Type.", type));
            }
            return builder.ToString();
        }

        /// <summary>
        /// Adds metadata to the given <paramref name="type"/>.
        /// </summary>
        /// <param name="type">Type for which metadata being generated.</param>
        /// <param name="serializedName">Serialized name to be used.</param>
        /// <param name="parameter">Parameter of the composite type to construct the parameter constraints.</param>
        /// <returns>Metadata as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for IParameter for IModelType.
        /// required: true | false,                         -- whether this property is required or not
        /// read_only: true | false,                        -- whether this property is read only or not. Default is false
        /// is_constant: true | false,                      -- whether this property is constant or not. Default is false
        /// serialized_name: 'name'                         -- serialized name of the property if provided
        /// default_value: 'value'                          -- default value of the property if provided
        /// constraints: {                                  -- constraints of the property
        ///   key: value,                                   -- constraint name and value if any
        ///   ***: *****
        /// }
        /// </example>
        private static string AddMetaData(this IModelType type, string serializedName, IVariable parameter)
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            Dictionary<Constraint, string> constraints = null;
            string defaultValue = null;
            bool isRequired = false;
            bool isConstant = false;
            bool isReadOnly = false;
            var property = parameter as Property;
            if (property != null)
            {
                isReadOnly = property.IsReadOnly;
            }
            if (parameter != null)
            {
                defaultValue = parameter.DefaultValue;
                isRequired = parameter.IsRequired;
                isConstant = parameter.IsConstant;
                constraints = parameter.Constraints;
            }

            CompositeType composite = type as CompositeType;
            if (composite != null && composite.ContainsConstantProperties && isRequired)
            {
                defaultValue = "{}";
            }

            if (isRequired)
            {
                builder.AppendLine("required: true,");
            }
            else
            {
                builder.AppendLine("required: false,");
            }
            if (isReadOnly)
            {
                builder.AppendLine("read_only: true,");
            }
            if (isConstant)
            {
                builder.AppendLine("is_constant: true,");
            }
            if (serializedName != null)
            {
                builder.AppendLine("serialized_name: '{0}',", serializedName);
            }
            if (defaultValue != null)
            {
                builder.AppendLine("default_value: {0},", defaultValue);
            }

            if (constraints != null && constraints.Count > 0)
            {
                builder.AppendLine("constraints: {").Indent();
                var keys = constraints.Keys.ToList<Constraint>();
                for (int j = 0; j < keys.Count; j++)
                {
                    var constraintValue = constraints[keys[j]];
                    if (keys[j] == Constraint.Pattern)
                    {
                        constraintValue = string.Format(CultureInfo.InvariantCulture, "'{0}'", constraintValue);
                    }
                    if (j != keys.Count - 1)
                    {
                        builder.AppendLine("{0}: {1},", keys[j], constraintValue);
                    }
                    else
                    {
                        builder.AppendLine("{0}: {1}", keys[j], constraintValue);
                    }
                }
                builder.Outdent()
                    .AppendLine("},");
            }

            return builder.ToString();
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="primary"/>.
        /// </summary>
        /// <param name="primary">PrimaryType for which mapper being generated.</param>
        /// <returns>Mapper for the <paramref name="primary"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for PrimaryType.
        /// type: {
        ///   name: 'Boolean'                               -- This value should be one of the KnownPrimaryType
        /// }
        /// </example>
        private static string ContructMapperForPrimaryType(this PrimaryType primary)
        {
            if (primary == null)
            {
                throw new ArgumentNullException(nameof(primary));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            if (primary.KnownPrimaryType == KnownPrimaryType.Boolean)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Boolean'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Double)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Double'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Int || primary.KnownPrimaryType == KnownPrimaryType.Long ||
                primary.KnownPrimaryType == KnownPrimaryType.Decimal)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Number'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.String || primary.KnownPrimaryType == KnownPrimaryType.Uuid)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'String'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.ByteArray)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'ByteArray'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Base64Url)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Base64Url'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Date)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Date'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.DateTime)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'DateTime'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'DateTimeRfc1123'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.TimeSpan)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'TimeSpan'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.UnixTime)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'UnixTime'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Object)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Object'").Outdent().AppendLine("}");
            }
            else if (primary.KnownPrimaryType == KnownPrimaryType.Stream)
            {
                builder.AppendLine("type: {").Indent().AppendLine("name: 'Stream'").Outdent().AppendLine("}");
            }
            else
            {
                throw new NotImplementedException(string.Format(CultureInfo.InvariantCulture, "{0} is not a supported primary Type for {1}.", primary.KnownPrimaryType, primary.Name));
            }

            return builder.ToString();
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="enumeration"/>.
        /// </summary>
        /// <param name="enumeration">EnumType for which mapper being generated.</param>
        /// <returns>Mapper for the <paramref name="enumeration"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for EnumType.
        /// type: {
        ///   name: 'Enum',
        ///   module: 'module_name'                         -- name of the module to be looked for enum values
        /// }
        /// </example>
        private static string ContructMapperForEnumType(this EnumTypeRb enumeration)
        {
            if (enumeration == null)
            {
                throw new ArgumentNullException(nameof(enumeration));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            builder.AppendLine("type: {").Indent()
                .AppendLine("name: 'Enum',")
                .AppendLine("module: '{0}'", enumeration.ModuleName).Outdent()
                .AppendLine("}");

            return builder.ToString();
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="sequence"/>.
        /// </summary>
        /// <param name="sequence">SequenceType for which mapper being generated.</param>
        /// <returns>Mapper for the <paramref name="sequence"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for SequenceType.
        /// type: {
        ///   name: 'Sequence',
        ///   element: {
        ///     ***                                         -- mapper of the IModelType from the sequence element
        ///   }
        /// }
        /// </example>
        private static string ContructMapperForSequenceType(this SequenceType sequence)
        {
            if (sequence == null)
            {
                throw new ArgumentNullException(nameof(sequence));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            builder.AppendLine("type: {").Indent()
                     .AppendLine("name: 'Sequence',")
                     .AppendLine("element: {").Indent()
                     .AppendLine("{0}", sequence.ElementType.ConstructMapper(sequence.ElementType.Name + "ElementType", null, false)).Outdent()
                     .AppendLine("}").Outdent()
                     .AppendLine("}");

            return builder.ToString();
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="dictionary"/>.
        /// </summary>
        /// <param name="dictionary">DictionaryType for which mapper being generated.</param>
        /// <returns>Mapper for the <paramref name="dictionary"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for DictionaryType.
        /// type: {
        ///   name: 'Dictionary',
        ///   value: {
        ///     ***                                         -- mapper of the IModelType from the value type of dictionary
        ///   }
        /// }
        /// </example>
        private static string ContructMapperForDictionaryType(this DictionaryType dictionary)
        {
            if (dictionary == null)
            {
                throw new ArgumentNullException(nameof(dictionary));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            builder.AppendLine("type: {").Indent()
                .AppendLine("name: 'Dictionary',")
                .AppendLine("value: {").Indent()
                .AppendLine("{0}", dictionary.ValueType.ConstructMapper(dictionary.ValueType.Name + "ElementType", null, false)).Outdent()
                .AppendLine("}").Outdent()
                .AppendLine("}");

            return builder.ToString();
        }

        /// <summary>
        /// Constructs blueprint of the given <paramref name="composite"/>.
        /// </summary>
        /// <param name="composite">CompositeType for which mapper being generated.</param>
        /// <param name="expandComposite">Expand composite type if <c>true</c> otherwise specify class_name in the mapper.</param>
        /// <returns>Mapper for the <paramref name="composite"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        /// <example>
        /// The below example shows possible mapper string for CompositeType.
        /// type: {
        ///   name: 'Composite',
        ///   polymorphic_discriminator: 'property_name',   -- name of the property for polymorphic discriminator
        ///                                                      Used only when x-ms-discriminator-value applied
        ///   uber_parent: 'parent_class_name',             -- name of the topmost level class on inheritance hierarchy
        ///                                                      Used only when x-ms-discriminator-value applied
        ///   class_name: 'class_name',                     -- name of the modeled class
        ///                                                      Used when <paramref name="expandComposite"/> is false
        ///   model_properties: {                           -- expanded properties of the model
        ///                                                      Used when <paramref name="expandComposite"/> is true
        ///     property_name : {                           -- name of the property of this composite type
        ///         ***                                     -- mapper of the IModelType from the type of the property
        ///     }
        ///   }
        /// }
        /// </example>
        private static string ContructMapperForCompositeType(this CompositeType composite, bool expandComposite)
        {
            if (composite == null)
            {
                throw new ArgumentNullException(nameof(composite));
            }

            IndentedStringBuilder builder = new IndentedStringBuilder("  ");

            builder.AppendLine("type: {").Indent()
                .AppendLine("name: 'Composite',");

            if (composite.IsPolymorphic)
            {
                builder.AppendLine("polymorphic_discriminator: '{0}',", composite.PolymorphicDiscriminator);
                var polymorphicType = composite;
                while (polymorphicType.BaseModelType != null)
                {
                    polymorphicType = polymorphicType.BaseModelType;
                }
                builder.AppendLine("uber_parent: '{0}',", polymorphicType.Name);
            }
            if (!expandComposite)
            {
                builder.AppendLine("class_name: '{0}'", composite.Name).Outdent().AppendLine("}");
            }
            else
            {
                builder.AppendLine("class_name: '{0}',", composite.Name)
                       .AppendLine("model_properties: {").Indent();

                // if the type is the base type, it doesn't get the the polymorphic discriminator here
                var composedPropertyList = composite.IsPolymorphic ? 
                    new List<Property>(composite.ComposedProperties.Where(each => !each.IsPolymorphicDiscriminator)) :
                    new List<Property>(composite.ComposedProperties);

                for (var i = 0; i < composedPropertyList.Count; i++)
                {
                    var prop = composedPropertyList[i];
                    var serializedPropertyName = prop.SerializedName;

                    if (i != composedPropertyList.Count - 1)
                    {
                        builder.AppendLine("{0}: {{{1}}},", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false));
                    }
                    else
                    {
                        builder.AppendLine("{0}: {{{1}}}", prop.Name, prop.ModelType.ConstructMapper(serializedPropertyName, prop, false));
                    }
                }
                // end of modelProperties and type
                builder.Outdent().
                    AppendLine("}").Outdent().
                    AppendLine("}");
            }

            return builder.ToString();
        }
    }
}
