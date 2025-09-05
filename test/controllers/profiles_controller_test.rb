require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get profile_path
    assert_response :success
  end

  test "should get show" do
    get profile_path
    assert_response :success
  end
end
