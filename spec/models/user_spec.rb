require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    new_time = Time.local(2015, 6, 1, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  after(:all) do
    Timecop.return
  end

  it "#name" do
    u = User.new(first_name: "Bob", last_name: "Smith")
    expect(u.name).to eq("Bob Smith")
  end

  it "#age" do
    u = User.new(DOB: Date.parse("7 June 1959"))
    expect(u.age).to eq(55)
  end
end
