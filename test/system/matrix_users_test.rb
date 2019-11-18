require "application_system_test_case"

class MatrixUsersTest < ApplicationSystemTestCase
  setup do
    @matrix_user = matrix_users(:one)
  end

  test "visiting the index" do
    visit matrix_users_url
    assert_selector "h1", text: "Matrix Users"
  end

  test "creating a Matrix user" do
    visit matrix_users_url
    click_on "New Matrix User"

    fill_in "Filial", with: @matrix_user.filial
    fill_in "Master profile", with: @matrix_user.master_profile
    fill_in "Pdv", with: @matrix_user.pdv
    fill_in "Sub agent", with: @matrix_user.sub_agent
    fill_in "Sub dist", with: @matrix_user.sub_dist
    fill_in "User", with: @matrix_user.user_id
    click_on "Create Matrix user"

    assert_text "Matrix user was successfully created"
    click_on "Back"
  end

  test "updating a Matrix user" do
    visit matrix_users_url
    click_on "Edit", match: :first

    fill_in "Filial", with: @matrix_user.filial
    fill_in "Master profile", with: @matrix_user.master_profile
    fill_in "Pdv", with: @matrix_user.pdv
    fill_in "Sub agent", with: @matrix_user.sub_agent
    fill_in "Sub dist", with: @matrix_user.sub_dist
    fill_in "User", with: @matrix_user.user_id
    click_on "Update Matrix user"

    assert_text "Matrix user was successfully updated"
    click_on "Back"
  end

  test "destroying a Matrix user" do
    visit matrix_users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Matrix user was successfully destroyed"
  end
end
