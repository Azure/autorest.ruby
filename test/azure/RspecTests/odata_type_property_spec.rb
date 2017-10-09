# encoding: utf-8

$: << 'RspecTests/Generated/odata_type_property'

require 'rspec'
require 'generated/odata_type_property'

include AzureODataTypePropertyModule

describe 'OdataTypeProperty' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AzureODataTypepropertyTest.new(@credentials, @base_url)
  end

  it 'should generate models with expected inheritance' do
    expect(AzureODataTypePropertyModule::Models::LocationThresholdRuleCondition.instance_methods.include? :odata_type).to eq(true)
    expect(AzureODataTypePropertyModule::Models::RuleCondition.instance_methods.include? :odata_type).to eq(true)
    expect(AzureODataTypePropertyModule::Models::RuleDataSource.instance_methods.include? :odata_type).to eq(true)
  end
end