require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_post_path
    assert_response :success
  end
end
