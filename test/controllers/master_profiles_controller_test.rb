require 'test_helper'

class MasterProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @master_profile = master_profiles(:one)
  end

  test "should get index" do
    get master_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_master_profile_url
    assert_response :success
  end

  test "should create master_profile" do
    assert_difference('MasterProfile.count') do
      post master_profiles_url, params: { master_profile: { description: @master_profile.description } }
    end

    assert_redirected_to master_profile_url(MasterProfile.last)
  end

  test "should show master_profile" do
    get master_profile_url(@master_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_master_profile_url(@master_profile)
    assert_response :success
  end

  test "should update master_profile" do
    patch master_profile_url(@master_profile), params: { master_profile: { description: @master_profile.description } }
    assert_redirected_to master_profile_url(@master_profile)
  end

  test "should destroy master_profile" do
    assert_difference('MasterProfile.count', -1) do
      delete master_profile_url(@master_profile)
    end

    assert_redirected_to master_profiles_url
  end
end
