## Important Announcement

As of February 2021, Azure Resource Management SDK for Ruby **has entered a retirement phase and is no longer officially supported by Microsoft**. Here is the complete list of packages that are affected by this. We are committed to making critical security and bug fixes for libraries in this repo until **December 31, 2021**. After that date, this repo will no longer be maintained.  

For current users of the Azure Resource Management SDK for Ruby, we have prepared a **migration guide** that points outlines different alternative approaches you can take moving forward. Please [check the guide here](https://github.com/Azure/azure-sdk-for-ruby/blob/master/docs/README.md). 

Thank you for your support so far. Should you have any question, please feel free to open an issue on GitHub. 

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# AutoRest extension configuration

``` yaml
use-extension:
  "@microsoft.azure/autorest.modeler": "2.1.22"

pipeline:
  ruby/modeler:
    input: swagger-document/identity
    output-artifact: code-model-v1
    scope: ruby
  ruby/commonmarker:
    input: modeler
    output-artifact: code-model-v1
  ruby/cm/transform:
    input: commonmarker
    output-artifact: code-model-v1
  ruby/cm/emitter:
    input: transform
    scope: scope-cm/emitter
  ruby/generate:
    plugin: ruby
    input: cm/transform
    output-artifact: source-file-ruby
  ruby/transform:
    input: generate
    output-artifact: source-file-ruby
    scope: scope-transform-string
  ruby/emitter:
    input: transform
    scope: scope-ruby/emitter

scope-ruby/emitter:
  input-artifact: source-file-ruby
  output-uri-expr: $key

output-artifact:
- source-file-ruby
```
