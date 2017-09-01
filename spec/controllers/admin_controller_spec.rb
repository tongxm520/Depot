require 'spec_helper'

describe AdminController do
  fixtures :users,:products

  before(:each) do
    user=users(:one)
    login_admin(user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
