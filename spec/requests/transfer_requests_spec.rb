require 'rails_helper'

RSpec.describe "Transfer requests", type: :request do
  let(:user) {
    User.create({
      first_name: "Mike",
      last_name: "Pence",
      address_line_1: "Flat 2",
      DOB: Date.parse("7 June 1959"),
    }).tap(&:save!)
  }
  let(:token) {
    user.tokens.create
  }

  let(:tx_attributes) {
    {
      "account_number_from" => "0123-4567-8901-234",
      "account_number_to" => "0123-4567-8901-235",
      "amount_pennies" => 1234,
      "country_code_from" => "JPN",
      "country_code_to" => "GBR",
    }
  }

  let(:json) { JSON.parse(response.body) }

  describe "POST /users/:user_id/transfers" do
    it "no token" do
      expect{
        post "/users/#{user.id}/transfers", params: tx_attributes
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "with token" do
      post "/users/#{user.id}/transfers", params: tx_attributes.merge(token_id: token.id)
      expect(Transfer.count).to eq(1)
      expect(
        Transfer.last
          .attributes
          .slice(*tx_attributes.keys)
      ).to eq(tx_attributes)
    end
  end

  describe "GET /users/:user_id/transfers/:id" do
    it "no token" do
      expect{
        tx = user.transfers.create(tx_attributes).tap(&:save!)
        get "/users/#{user.id}/transfers/#{tx.id}"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "with token" do
      tx = user.transfers.create(tx_attributes).tap(&:save!)
      get "/users/#{user.id}/transfers/#{tx.id}", params: {token_id: token.id}
      expect(json).to eq({
        "account_number_from" => "0123-4567-8901-234",
        "account_number_to" => "0123-4567-8901-235",
        "amount_pennies" => 1234,
        "country_code_from" => "JPN",
        "country_code_to" => "GBR",
      })
    end
  end

  describe "DELETE /users/:user_id/transfers/:id" do
    it "no token" do
      expect{
        tx1 = user.transfers.create(tx_attributes).tap(&:save!)
        tx2 = user.transfers.create(tx_attributes).tap(&:save!)
        delete "/users/#{user.id}/transfers/#{tx1.id}"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "with token" do
      tx1 = user.transfers.create(tx_attributes).tap(&:save!)
      tx2 = user.transfers.create(tx_attributes).tap(&:save!)
      delete "/users/#{user.id}/transfers/#{tx1.id}", params: {token_id: token.id}
      expect(Transfer.count).to eq(1)
      expect(Transfer.last.id).to eq(tx2.id)
    end
  end

  # This is really PATCH not PUT
  describe "PUT /users/:user_id/transfers/:id" do
    it "no token" do
      expect{
        tx1 = user.transfers.create(tx_attributes).tap(&:save!)
        put "/users/#{user.id}/transfers/#{tx1.id}", params: {amount_pennies: 5678}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "with token" do
      tx1 = user.transfers.create(tx_attributes).tap(&:save!)
      put "/users/#{user.id}/transfers/#{tx1.id}", params: {amount_pennies: 5678, token_id: token.id}
      expect(Transfer.last.attributes.slice("amount_pennies", "country_code_from")).to eq({
        "country_code_from" => "JPN",
        "amount_pennies" => 5678,
      })
    end
  end
end
