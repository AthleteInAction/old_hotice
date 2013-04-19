require 'test_helper'

class ZendeskFieldsControllerTest < ActionController::TestCase
  setup do
    @zendesk_field = zendesk_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zendesk_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zendesk_field" do
    assert_difference('ZendeskField.count') do
      post :create, zendesk_field: { active: @zendesk_field.active, db_name: @zendesk_field.db_name, display_name: @zendesk_field.display_name, required: @zendesk_field.required, state: @zendesk_field.state }
    end

    assert_redirected_to zendesk_field_path(assigns(:zendesk_field))
  end

  test "should show zendesk_field" do
    get :show, id: @zendesk_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @zendesk_field
    assert_response :success
  end

  test "should update zendesk_field" do
    put :update, id: @zendesk_field, zendesk_field: { active: @zendesk_field.active, db_name: @zendesk_field.db_name, display_name: @zendesk_field.display_name, required: @zendesk_field.required, state: @zendesk_field.state }
    assert_redirected_to zendesk_field_path(assigns(:zendesk_field))
  end

  test "should destroy zendesk_field" do
    assert_difference('ZendeskField.count', -1) do
      delete :destroy, id: @zendesk_field
    end

    assert_redirected_to zendesk_fields_path
  end
end
