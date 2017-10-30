require 'rails_helper'

RSpec.describe "Token requests", type: :request do
  let(:user) {
    User.create({
      first_name: "Mike",
      last_name: "Pence",
      address_line_1: "Flat 2",
      DOB: Date.parse("7 June 1959"),
    }).tap(&:save!)
  }

  describe "POST /users/:user_id/tokens" do
    it "no password" do
      post "/users/#{user.id}/tokens"
      expect(response.code).to eq("500")
      expect(Token.count).to eq(0)
    end

    it "bad password" do
      post "/users/#{user.id}/tokens", params: {password: "123456"}
      expect(response.code).to eq("500")
      expect(Token.count).to eq(0)
    end

    it "good password" do
      post "/users/#{user.id}/tokens", params: {password: "password"}
      expect(response.code).to eq("200")
      expect(Token.count).to eq(1)
    end
  end
end
