require "test_helper"

class AutomationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @automation = automations(:one)
  end

  test "should get index" do
    get automations_url, as: :json
    assert_response :success
  end

  test "should create automation" do
    assert_difference("Automation.count") do
      post automations_url, params: { automation: { Date: @automation.Date, company_id: @automation.company_id, message: @automation.message, programmed_to: @automation.programmed_to, sent_at: @automation.sent_at, tipo: @automation.tipo } }, as: :json
    end

    assert_response :created
  end

  test "should show automation" do
    get automation_url(@automation), as: :json
    assert_response :success
  end

  test "should update automation" do
    patch automation_url(@automation), params: { automation: { Date: @automation.Date, company_id: @automation.company_id, message: @automation.message, programmed_to: @automation.programmed_to, sent_at: @automation.sent_at, tipo: @automation.tipo } }, as: :json
    assert_response :success
  end

  test "should destroy automation" do
    assert_difference("Automation.count", -1) do
      delete automation_url(@automation), as: :json
    end

    assert_response :no_content
  end
end
