require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get edit" do
    get edit_profile_path
    assert_response :success
  end

  test "should get show" do
    get profile_path
    assert_response :success
  end
end
