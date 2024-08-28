require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:all) do
    @user = User.create("name":"Auth Test","email":"auth@email.com", "last_pin": 12345, "pin_sent_at": Time.now)
  end

  after(:all) do
    @user.destroy
  end

  describe "POST /authenticate" do
    it "test login" do
      params = {:email => @user.email, :code => @user.last_pin}
      
      post '/authenticate', params: params
      expect(response).to have_http_status :ok
    end
  end
end
