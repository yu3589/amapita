require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create!(name: "Cookie", slug: "cookie")
  end

  test "should get index" do
    get categories_path
    assert_response :success
  end

  test "should get show" do
    get category_path(@category.slug)
    assert_response :success
  end
end
