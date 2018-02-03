# encoding: utf-8

$: << 'RspecTests/Generated/parameters_constraints'

require 'rspec'
require 'generated/parameters_constraints'

include AzureParametersConstraintsModule

describe 'AzureParametersConstraints' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AzureParametersConstraintsTest.new(@credentials, @base_url)
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

  it 'should error out on inclusive maximum minimum parameter violates on maximum value' do
    @inclusive_maximum_minimum_parameter = 11
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'inclusive_maximum_minimum_parameter' should satisfy the constraint - 'InclusiveMaximum': '10'")
  end

  it 'should error out on inclusive maximum minimum parameter violates on minimum value' do
    @inclusive_maximum_minimum_parameter = 3
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'inclusive_maximum_minimum_parameter' should satisfy the constraint - 'InclusiveMinimum': '5'")
  end

  it 'should error out on exclusive maximum minimum parameter violates on maximum value' do
    @exclusive_maximum_minimum_parameter = 10
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'exclusive_maximum_minimum_parameter' should satisfy the constraint - 'ExclusiveMaximum': '10'")
  end

  it 'should error out on exclusive maximum minimum parameter violates on minimum value' do
    @exclusive_maximum_minimum_parameter = 5
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'exclusive_maximum_minimum_parameter' should satisfy the constraint - 'ExclusiveMinimum': '5'")
  end

  it 'should error out on maximum minimum length parameter violates on maximum value' do
    @maximum_minimum_length_parameter = "dummy_parameter"
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'maximum_minimum_length_parameter' should satisfy the constraint - 'MaxLength': '10'")
  end

  it 'should error out on maximum minimum length parameter violates on minimum value' do
    @maximum_minimum_length_parameter = "dmy"
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'maximum_minimum_length_parameter' should satisfy the constraint - 'MinLength': '5'")
  end

  it 'should error out on maximum minimum items parameter violates on maximum value' do
    @maximum_minimum_items_parameter = ['a', 'b', 'c', 'd', 'e', 'f']
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'maximum_minimum_items_parameter' should satisfy the constraint - 'MaxItems': '5'")
  end

  it 'should error out on maximum minimum items parameter violates on minimum value' do
    @maximum_minimum_items_parameter = ['a']
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'maximum_minimum_items_parameter' should satisfy the constraint - 'MinItems': '2'")
  end

  it 'should error out on unique items parameter violates on uniqueness' do
    @unique_items_parameter = ['a', 'b', 'a']
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'unique_items_parameter' should satisfy the constraint - 'UniqueItems'")
  end

  it 'should error out on resource group name parameter violates on pattern' do
    @resource_group_name = '#123samrg'
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'resource_group_name' should satisfy the constraint - 'Pattern': '[a-zA-Z0-9]+'")
  end

  it 'should error out on id parameter violates on multipleof' do
    @id = 101
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to raise_error(ArgumentError, "'id' should satisfy the constraint - 'MultipleOf': '10'")
  end

  it 'should not error out on no violations' do
    expect {
      @client.validation_of_method_parameters_async(
        @resource_group_name,
        @id,
        @inclusive_maximum_minimum_parameter,
        @exclusive_maximum_minimum_parameter,
        @maximum_minimum_length_parameter,
        maximum_minimum_items_parameter:@maximum_minimum_items_parameter,
        unique_items_parameter:@unique_items_parameter
      )
    }.to_not raise_error
  end
end