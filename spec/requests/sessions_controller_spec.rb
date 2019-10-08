require "rails_helper"

RSpec.describe "sessions controller", type: :request do

  it "should get new" do
    get login_path
    assert_response :success
  end

end
