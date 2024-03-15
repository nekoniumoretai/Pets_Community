require "test_helper"

class User::GroupMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_group_messages_new_url
    assert_response :success
  end

  test "should get index" do
    get user_group_messages_index_url
    assert_response :success
  end
end
