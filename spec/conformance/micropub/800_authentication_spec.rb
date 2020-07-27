# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Micropub Server Implementation Report - Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:application) }
  let(:access_token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  before { post '/micropub', params: params, headers: headers }

  # https://micropub.rocks/server-tests/800?endpoint=501
  pending '800 - Accept access token in HTTP header'

  # https://micropub.rocks/server-tests/801?endpoint=501
  pending '801 - Accept access token in POST body'

  # https://micropub.rocks/server-tests/802?endpoint=501
  pending '802 - Does not store access token property'

  # https://micropub.rocks/server-tests/803?endpoint=501
  pending '803 - Rejects unauthenticated requests'

  # https://micropub.rocks/server-tests/804?endpoint=501
  pending '804 - Rejects unauthorized access tokens'
end
