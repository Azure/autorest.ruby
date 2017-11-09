# encoding: utf-8

$: << 'RspecTests/Generated/constraints_no_validations'

require 'rspec'
require 'generated/constraints_no_validations'

include AzureConstraintsNoValidationsModule

describe 'AzureConstraintsNoValidations' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AzureConstraintsNoValidations.new(@credentials, @base_url)
  end

  before do
    @client.subscription_id = 'dummy_subscription_id'
    @client.api_version = '2017-01-01'

    @resource_group_name = 'rgname'
    @id = 500
    @inclusive_maximum_minimum_parameter = 8
    @exclusive_maximum_minimum_parameter = 8
    @maximum_minimum_length_parameter = 'dummy_pm'
    @maximum_minimum_items_parameter = ['a', 'b', 'c']
    @unique_items_parameter = ['a', 'b', 'c']
  end

  it 'should not error out on inclusive maximum minimum parameter violation on maximum value' do
    @inclusive_maximum_minimum_parameter = 11
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        @maximum_minimum_items_parameter,
        @unique_items_parameter
      )
    }.to_not raise_error
  end

end