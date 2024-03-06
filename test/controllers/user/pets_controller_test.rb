require "test_helper"

class User::PetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_pets_new_url
    assert_response :success
  end

  test "should get index" do
    get user_pets_index_url
    assert_response :success
  end

  test "should get show" do
    get user_pets_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_pets_edit_url
    assert_response :success
  end
end
