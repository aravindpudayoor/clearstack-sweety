require "rails_helper"

RSpec.describe GlucoseLevelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/glucose_levels").to route_to("glucose_levels#index")
    end

    it "routes to #new" do
      expect(:get => "/glucose_levels/new").to route_to("glucose_levels#new")
    end

    it "routes to #show" do
      expect(:get => "/glucose_levels/1").to route_to("glucose_levels#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/glucose_levels/1/edit").to route_to("glucose_levels#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/glucose_levels").to route_to("glucose_levels#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/glucose_levels/1").to route_to("glucose_levels#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/glucose_levels/1").to route_to("glucose_levels#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/glucose_levels/1").to route_to("glucose_levels#destroy", :id => "1")
    end
  end
end
