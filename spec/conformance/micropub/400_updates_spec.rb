# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Updates', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'application/json'
    }
  end

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/400?endpoint=501
  pending '400 - Replace a property'

  # https://micropub.rocks/server-tests/401?endpoint=501
  pending '401 - Add a value to an existing property'

  # https://micropub.rocks/server-tests/402?endpoint=501
  pending '402 - Add a value to a non-existent property'

  # https://micropub.rocks/server-tests/403?endpoint=501
  pending '403 - Remove a value from a property'

  # https://micropub.rocks/server-tests/404?endpoint=501
  pending '404 - Remove a property'

  # https://micropub.rocks/server-tests/405?endpoint=501
  pending '405 - Reject the request if operation is not an array'
end
