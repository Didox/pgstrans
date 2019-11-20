require "application_system_test_case"

class MasterProfilesTest < ApplicationSystemTestCase
  setup do
    @master_profile = master_profiles(:one)
  end

  test "visiting the index" do
    visit master_profiles_url
    assert_selector "h1", text: "Master Profiles"
  end

  test "creating a Master profile" do
    visit master_profiles_url
    click_on "New Master Profile"

    fill_in "Description", with: @master_profile.description
    click_on "Create Master profile"

    assert_text "Master profile was successfully created"
    click_on "Back"
  end

  test "updating a Master profile" do
    visit master_profiles_url
    click_on "Edit", match: :first

    fill_in "Description", with: @master_profile.description
    click_on "Update Master profile"

    assert_text "Master profile was successfully updated"
    click_on "Back"
  end

  test "destroying a Master profile" do
    visit master_profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Master profile was successfully destroyed"
  end
end
