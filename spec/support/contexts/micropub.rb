# frozen_string_literal: true

RSpec.shared_context 'when authenticated as a valid Micropub client' do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:site_url) { 'https://example.com' }
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }
  let(:access_token) do
    FactoryBot.create(
      :oauth_access_token,
      application: application,
      resource_owner_id: user.id,
      scopes: %i[create media profile]
    )
  end
  let(:content_type) { 'application/x-www-form-urlencoded; charset=utf-8' }

  let(:headers) do
    {
      'Authorization' => "Bearer #{access_token.token}",
      'Content-Type' => content_type
    }
  end

  before do
    allow(Rails.configuration.x.site).to receive(:url) { site_url }
  end
end
