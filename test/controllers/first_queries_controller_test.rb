require 'test_helper'

class FirstQueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @first_query = first_queries(:one)
  end

  test "should get index" do
    get first_queries_url
    assert_response :success
  end

  test "should get new" do
    get new_first_query_url
    assert_response :success
  end

  test "should create first_query" do
    assert_difference('FirstQuery.count') do
      post first_queries_url, params: { first_query: { query: @first_query.query, queryID: @first_query.queryID, sUserID: @first_query.sUserID } }
    end

    assert_redirected_to first_query_url(FirstQuery.last)
  end

  test "should show first_query" do
    get first_query_url(@first_query)
    assert_response :success
  end

  test "should get edit" do
    get edit_first_query_url(@first_query)
    assert_response :success
  end

  test "should update first_query" do
    patch first_query_url(@first_query), params: { first_query: { query: @first_query.query, queryID: @first_query.queryID, sUserID: @first_query.sUserID } }
    assert_redirected_to first_query_url(@first_query)
  end

  test "should destroy first_query" do
    assert_difference('FirstQuery.count', -1) do
      delete first_query_url(@first_query)
    end

    assert_redirected_to first_queries_url
  end
end
