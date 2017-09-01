require "spec_helper"

describe LineItemsController do
  describe "routing" do
    it "routes to #create" do
      post("/line_items").should route_to("line_items#create")
    end    
  end
end
