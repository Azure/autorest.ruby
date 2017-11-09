
###############################################
# LEGACY 
# Instead: have bunch of configuration files sitting in a well-known spot, discover them, feed them to AutoRest, done.

regenExpected = (opts,done) ->
  outputDir = if !!opts.outputBaseDir then "#{opts.outputBaseDir}/#{opts.outputDir}" else opts.outputDir
  keys = Object.getOwnPropertyNames(opts.mappings)
  instances = keys.length

  for kkey in keys
    optsMappingsValue = opts.mappings[kkey]
    key = kkey.trim();
    
    swaggerFiles = (if optsMappingsValue instanceof Array then optsMappingsValue[0] else optsMappingsValue).split(";")
    args = [
      "--#{opts.language}",
      "--output-folder=#{outputDir}/#{key}",
      "--license-header=#{if !!opts.header then opts.header else 'MICROSOFT_MIT_NO_VERSION'}",
      "--enable-xml"
    ]

    for swaggerFile in swaggerFiles
      args.push("--input-file=#{if !!opts.inputBaseDir then "#{opts.inputBaseDir}/#{swaggerFile}" else swaggerFile}")

    if (opts.addCredentials)
      args.push("--#{opts.language}.add-credentials=true")

    if (opts.azureArm)
      args.push("--#{opts.language}.azure-arm=true")

    if (opts.fluent)
      args.push("--#{opts.language}.fluent=true")
    
    if (opts.syncMethods)
      args.push("--#{opts.language}.sync-methods=#{opts.syncMethods}")
    
    if (opts.flatteningThreshold)
      args.push("--#{opts.language}.payload-flattening-threshold=#{opts.flatteningThreshold}")

    if (!!opts.nsPrefix)
      if (optsMappingsValue instanceof Array && optsMappingsValue[1] != undefined)
        args.push("--#{opts.language}.namespace=#{optsMappingsValue[1]}")
      else
        args.push("--#{opts.language}.namespace=#{[opts.nsPrefix, key.replace(/\/|\./, '')].join('.')}")

    if (opts['override-info.version'])
      args.push("--override-info.version=#{opts['override-info.version']}")
    if (opts['override-info.title'])
      args.push("--override-info.title=#{opts['override-info.title']}")
    if (opts['override-info.description'])
      args.push("--override-info.description=#{opts['override-info.description']}")

    if (typeof opts.clientSideValidation != 'undefined')
      if (!opts.clientSideValidation)
        args.push("--client-side-validation=false")

    autorest args,() =>
      instances--
      return done() if instances is 0 

rubyMappings = {
  'boolean':['body-boolean.json', 'BooleanModule'],
  'integer':['body-integer.json','IntegerModule'],
  'number':['body-number.json','NumberModule'],
  'string':['body-string.json','StringModule'],
  'byte':['body-byte.json','ByteModule'],
  'array':['body-array.json','ArrayModule'],
  'dictionary':['body-dictionary.json','DictionaryModule'],
  'date':['body-date.json','DateModule'],
  'datetime':['body-datetime.json','DatetimeModule'],
  'datetime_rfc1123':['body-datetime-rfc1123.json','DatetimeRfc1123Module'],
  'duration':['body-duration.json','DurationModule'],
  'complex':['body-complex.json','ComplexModule'],
  'url':['url.json','UrlModule'],
  'url_items':['url.json','UrlModule'],
  'url_query':['url.json','UrlModule'],
  'header_folder':['header.json','HeaderModule'],
  'http_infrastructure':['httpInfrastructure.json','HttpInfrastructureModule'],
  'required_optional':['required-optional.json','RequiredOptionalModule'],
  'report':['report.json','ReportModule'],
  'model_flattening':['model-flattening.json', 'ModelFlatteningModule'],
  'parameter_flattening':['parameter-flattening.json', 'ParameterFlatteningModule'],
  'validation':['validation.json', 'ValidationModule'],
  'custom_base_uri':['custom-baseUrl.json', 'CustomBaseUriModule'],
  'custom_base_uri_more':['custom-baseUrl-more-options.json', 'CustomBaseUriMoreModule']  
}

rubyAzureMappings = {
  'head':['head.json', 'HeadModule'],
  'head_exceptions':['head-exceptions.json', 'HeadExceptionsModule'],
  'paging':['paging.json', 'PagingModule'],
  'azure_resource':['azure-resource.json', 'AzureResourceModule'],
  'lro':['lro.json', 'LroModule'],
  'azure_url':['subscriptionId-apiVersion.json', 'AzureUrlModule'],
  'azure_special_properties': ['azure-special-properties.json', 'AzureSpecialPropertiesModule'],
  'azure_report':['azure-report.json', 'AzureReportModule'],
  'parameter_grouping':['azure-parameter-grouping.json', 'ParameterGroupingModule']
}

rubyAzureAdditionalMappings = {
  'azure_resource_inheritance': ['resource_inheritance.json', 'AzureResourceInheritanceModule'],
  'odata_type_property': ['odata_type_property.json', 'AzureODataTypePropertyModule']
}

rubyValidationsMappings = {
  'parameters_constraints': ['parameters_constraints.json', 'AzureParametersConstraintsModule']
}

rubyNoValidationsMappings = {
  'constraints_no_validations': ['constraints_no_validations.json', 'AzureConstraintsNoValidationsModule']
}

swaggerDir = "node_modules/@microsoft.azure/autorest.testserver/swagger"

task 'regenerate-rubyazure', '', (done) ->
  regenExpected {
    'outputBaseDir': 'test/azure',
    'inputBaseDir': swaggerDir,
    'mappings': rubyAzureMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'azureArm': true,
    'nsPrefix': 'MyNamespace'
  },done
  return null

testSwaggerDir = "test/swagger"

task 'regenerate-ruby-validations', '', (done) ->
  regenExpected {
    'outputBaseDir': 'test/vanilla',
    'inputBaseDir': testSwaggerDir,
    'mappings': rubyValidationsMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate-ruby-novalidation', '', (done) ->
  regenExpected {
    'outputBaseDir': 'test/vanilla',
    'inputBaseDir': testSwaggerDir,
    'mappings': rubyNoValidationsMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'nsPrefix': 'MyNamespace',
    'clientSideValidation': false
  },done
  return null

task 'regenerate-rubyazure-additional', '', (done) ->
  regenExpected {
    'outputBaseDir': 'test/azure',
    'inputBaseDir': testSwaggerDir,
    'mappings': rubyAzureAdditionalMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'azureArm': true,
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate-ruby', '', (done) ->
  regenExpected {
    'outputBaseDir': 'test/vanilla',
    'inputBaseDir': swaggerDir,
    'mappings': rubyMappings,
    'outputDir': 'RspecTests/Generated',
    'language': 'ruby',
    'nsPrefix': 'MyNamespace'
  },done
  return null

task 'regenerate', "regenerate expected code for tests", ['regenerate-ruby', 'regenerate-rubyazure', 'regenerate-rubyazure-additional', 'regenerate-ruby-validations', 'regenerate-ruby-novalidation'], (done) ->
  done();