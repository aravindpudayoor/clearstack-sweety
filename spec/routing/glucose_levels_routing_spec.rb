require "rails_helper"

RSpec.describe GlucoseLevelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/glucose_levels").to route_to("glucose_levels#index")
    end

    it "routes to #new" do
      expect(:get => "/glucose_levels/new").to route_to("glucose_levels#new")
    end

    it "routes to #create" do
      expect(:post => "/glucose_levels").to route_to("glucose_levels#create")
    end
  end
end
