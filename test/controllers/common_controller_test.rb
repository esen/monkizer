require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  test "should get get_adb_ids" do
    get :get_adb_ids
    assert_response :success
  end

end
