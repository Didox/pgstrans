require 'test_helper'

class MatrixUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @matrix_user = matrix_users(:one)
  end

  test "should get index" do
    get matrix_users_url
    assert_response :success
  end

  test "should get new" do
    get new_matrix_user_url
    assert_response :success
  end

  test "should create matrix_user" do
    assert_difference('MatrixUser.count') do
      post matrix_users_url, params: { matrix_user: { filial: @matrix_user.filial, master_profile: @matrix_user.master_profile, pdv: @matrix_user.pdv, sub_agent: @matrix_user.sub_agent, sub_dist: @matrix_user.sub_dist, user_id: @matrix_user.usuario_id } }
    end

    assert_redirected_to matrix_user_url(MatrixUser.last)
  end

  test "should show matrix_user" do
    get matrix_user_url(@matrix_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_matrix_user_url(@matrix_user)
    assert_response :success
  end

  test "should update matrix_user" do
    patch matrix_user_url(@matrix_user), params: { matrix_user: { filial: @matrix_user.filial, master_profile: @matrix_user.master_profile, pdv: @matrix_user.pdv, sub_agent: @matrix_user.sub_agent, sub_dist: @matrix_user.sub_dist, user_id: @matrix_user.usuario_id } }
    assert_redirected_to matrix_user_url(@matrix_user)
  end

  test "should destroy matrix_user" do
    assert_difference('MatrixUser.count', -1) do
      delete matrix_user_url(@matrix_user)
    end

    assert_redirected_to matrix_users_url
  end
end
