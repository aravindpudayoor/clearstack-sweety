require 'rails_helper'

RSpec.describe GlucoseLevel, type: :model do
	it "is valid with valid attributes" do
		expect(build(:glucose_level, user: build(:user))).to be_valid
	end

  it "is not valid with out value" do
  	glucose_level = GlucoseLevel.new(user: build(:user))
  	expect(glucose_level).not_to be_valid
  end

  it "is not valid with value less than 50" do
    glucose_level = GlucoseLevel.new(value: 40, user: build(:user))
    expect(glucose_level).not_to be_valid
  end

  it "is not valid with value greater than 200" do
    glucose_level = GlucoseLevel.new(value: 240, user: build(:user))
    expect(glucose_level).not_to be_valid
  end

  it "is valid with the a value beetween 50 and 200" do
    glucose_level = build(:glucose_level, user: build(:user))
    expect(glucose_level).to be_valid
  end

  it "belongs to user" do
    expect(GlucoseLevel.reflect_on_association(:user).macro).to eq :belongs_to
  end

  it { should callback(:check_daily_limit).before(:validation) }
end
