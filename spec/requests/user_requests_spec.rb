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
  let(:lady_gaga) {
    {
      first_name: "Lady",
      last_name: "Gaga",
      address_line_1: "42 Fabulous Avenue",
      DOB: Date.parse("28 March 1986"),
    }
  }

  it "POST /users" do
    post("/users", params: lady_gaga)
    expect(User.count).to eq(1)
    expect(
      User.last
        .attributes
        .slice("first_name", "last_name", "address_line_1", "DOB")
    ).to eq({
      "first_name"=>"Lady",
      "last_name"=>"Gaga",
      "address_line_1"=>"42 Fabulous Avenue",
      "DOB"=>Date.parse("1986-03-28"),
    })
  end

  it "GET /users/:id" do
    u = User.create(mike_pence).tap(&:save!)
    get("/users/#{u.id}")
    expect(json).to eq({
      "name" => "Mike Pence",
      "age" => 55,
    })
  end

  it "DELETE /users/:id" do
    m = User.create(mike_pence).tap(&:save!)
    l = User.create(lady_gaga).tap(&:save!)
    delete("/users/#{m.id}")
    expect(User.count).to eq(1)
    expect(User.last.id).to eq(l.id)
  end

  # This is really PATCH not PUT
  it "PUT /users/:id" do
    m = User.create(mike_pence).tap(&:save!)
    put("/users/#{m.id}", params: {first_name: "Michael"})
    expect(User.last.name).to eq("Michael Pence")
  end
end
