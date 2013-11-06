require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get library" do
    get :library
    assert_response :success
  end

end
