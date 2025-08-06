require "test_helper"

class DiagnosesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_diagnosis_path
    assert_response :success
  end
end
