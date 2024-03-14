require "test_helper"

class DecomojisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decomojis_index_url
    assert_response :success
  end
end
