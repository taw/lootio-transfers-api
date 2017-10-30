require 'rails_helper'

RSpec.describe "User requests", type: :request do
  before(:all) do
    new_time = Time.local(2015, 6, 1, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  after(:all) do
    Timecop.return
  end

  let(:json) { JSON.parse(response.body) }

  let(:mike_pence) {
    {
      first_name: "Mike",
      last_name: "Pence",
      address_line_1: "Flat 2",
      DOB: Date.parse("7 June 1959"),
    }
  }

  it "POST /users" do

  end

  it "GET /users/:id" do
    u = User.create(mike_pence)
    u.save!
    get("/users/#{u.id}")
    expect(json).to eq({
      "name" => "Mike Pence",
      "age" => 55,
    })
  end

  it "DELETE /users/:id" do

  end

  it "PUT /users/:id" do

  end
end
