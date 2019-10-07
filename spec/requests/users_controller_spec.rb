require 'rails_helper'

RSpec.describe "users controller", type: :request do

  it "should get new" do
    get signup_path
    assert_response :success
  end
end
