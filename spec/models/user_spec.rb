require 'rails_helper'

RSpec.describe User, type: :model do

	it "is not valid with out email" do
		user = User.new
		expect(user).not_to be_valid
	end

  it "has many glucose level readings" do
    expect(User.reflect_on_association(:glucose_levels).macro).to eq :has_many
  end
end
