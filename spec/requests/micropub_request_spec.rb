require 'rails_helper'

RSpec.describe "Micropubs", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/micropub/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/micropub/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/micropub/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
