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

  it "POST /users/:user_id/transfers" do
    post "/users/#{user.id}/transfers", params: tx_attributes
    expect(Transfer.count).to eq(1)
    expect(
      Transfer.last
        .attributes
        .slice(*tx_attributes.keys)
    ).to eq(tx_attributes)
  end

  it "GET /users/:user_id/transfers/:id" do
    tx = user.transfers.create(tx_attributes).tap(&:save!)
    get "/users/#{user.id}/transfers/#{tx.id}"
    expect(json).to eq({
      "account_number_from" => "0123-4567-8901-234",
      "account_number_to" => "0123-4567-8901-235",
      "amount_pennies" => 1234,
      "country_code_from" => "JPN",
      "country_code_to" => "GBR",
    })
  end

  it "DELETE /users/:user_id/transfers/:id" do
    tx1 = user.transfers.create(tx_attributes).tap(&:save!)
    tx2 = user.transfers.create(tx_attributes).tap(&:save!)
    delete "/users/#{user.id}/transfers/#{tx1.id}"
    expect(Transfer.count).to eq(1)
    expect(Transfer.last.id).to eq(tx2.id)
  end

  # This is really PATCH not PUT
  it "PUT /users/:user_id/transfers/:id" do
    tx1 = user.transfers.create(tx_attributes).tap(&:save!)
    put "/users/#{user.id}/transfers/#{tx1.id}", params: {amount_pennies: 5678}
    expect(Transfer.last.attributes.slice("amount_pennies", "country_code_from")).to eq({
      "country_code_from" => "JPN",
      "amount_pennies" => 5678,
    })
  end
end
