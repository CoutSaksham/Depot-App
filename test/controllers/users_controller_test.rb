require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
    assert_select 'input[name="user[address_attributes][state]"]'
    assert_select 'input[name="user[address_attributes][pincode]"]'
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { name: "sam", password: "secret", password_confirmation: "secret" } }
    end

    assert_redirected_to users_url
  end

  test "should create user with nested address" do
    assert_difference([ "User.count", "Address.count" ]) do
      post users_url, params: {
        user: {
          name: "sam",
          email: "sam@example.com",
          password: "secret",
          password_confirmation: "secret",
          address_attributes: {
            state: "CA",
            city: "Oakland",
            country: "USA",
            pincode: 94612
          }
        }
      }
    end

    assert_equal 94612, User.find_by!(email: "sam@example.com").address.pincode
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { name: @user.name, password: "secret", password_confirmation: "secret" } }
    assert_redirected_to users_url
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
