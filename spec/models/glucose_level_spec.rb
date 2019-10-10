require 'rails_helper'

RSpec.describe GlucoseLevel, type: :model do
	it "is valid with valid attributes" do
		expect(FactoryGirl.build(:glucose_level, user: FactoryGirl.build(:user))).to be_valid
	end

  it "is not valid with out value" do
  	glucose_level = GlucoseLevel.new
  	expect(glucose_level).not_to be_valid
  end
  
  it "belongs to user" do
    expect(GlucoseLevel.reflect_on_association(:user).macro).to eq :belongs_to
  end
end
