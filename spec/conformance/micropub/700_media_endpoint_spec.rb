# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Media Endpoint', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => 'multipart/form-data'
    }
  end

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/700?endpoint=501
  pending '700 - Upload a jpg to the Media Endpoint'

  # https://micropub.rocks/server-tests/701?endpoint=501
  pending '701 - Upload a png to the Media Endpoint'

  # https://micropub.rocks/server-tests/702?endpoint=501
  pending '702 - Upload a gif to the Media Endpoint'
end
