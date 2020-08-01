require 'rails_helper'

RSpec.describe '/health', type: :request do
  it 'returns HTTP no content' do
    get '/health'
    expect(response).to have_http_status(:no_content)
  end
end
