require "application_system_test_case"

class ProvincesTest < ApplicationSystemTestCase
  setup do
    @province = provinces(:one)
  end

  test "visiting the index" do
    visit provinces_url
    assert_selector "h1", text: "Provinces"
  end

  test "should create province" do
    visit provinces_url
    click_on "New province"

    click_on "Create Province"

    assert_text "Province was successfully created"
    click_on "Back"
  end

  test "should update Province" do
    visit province_url(@province)
    click_on "Edit this province", match: :first

    click_on "Update Province"

    assert_text "Province was successfully updated"
    click_on "Back"
  end

  test "should destroy Province" do
    visit province_url(@province)
    click_on "Destroy this province", match: :first

    assert_text "Province was successfully destroyed"
  end
end
