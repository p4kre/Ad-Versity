require "test_helper"

class AudiencesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audiences_index_url
    assert_response :success
  end

  test "should get show" do
    get audiences_show_url
    assert_response :success
  end

  test "should get new" do
    get audiences_new_url
    assert_response :success
  end

  test "should get edit" do
    get audiences_edit_url
    assert_response :success
  end
end
