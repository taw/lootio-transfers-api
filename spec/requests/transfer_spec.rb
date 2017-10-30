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
      account_number_from: "0123-4567-8901-234",
      account_number_to: "0123-4567-8901-235",
      amount_pennies: 1234,
      country_code_from: "JPN",
      country_code_to: "GBR",
    }
  }

  let(:json) { JSON.parse(response.body) }

  pending "POST /users/:user_id/transfers"

  it "GET /users/:user_id/transfers/:id" do
    tx = user.transfers.create(tx_attributes)
    tx.save!
    get "/users/#{user.id}/transfers/#{tx.id}"
    expect(json).to eq({
      "account_number_from" => "0123-4567-8901-234",
      "account_number_to" => "0123-4567-8901-235",
      "amount_pennies" => 1234,
      "country_code_from" => "JPN",
      "country_code_to" => "GBR",
    })
  end

  pending "DELETE /users/:user_id/transfers/:id"

  pending "PUT /users/:user_id/transfers/:id"
end
