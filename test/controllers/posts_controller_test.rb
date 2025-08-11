require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get new" do
    user = users(:one)
    sign_in user

    get new_post_path
    assert_response :success
  end
end
