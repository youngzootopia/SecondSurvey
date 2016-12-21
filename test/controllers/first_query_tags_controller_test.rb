require 'test_helper'

class FirstQueryTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @first_query_tag = first_query_tags(:one)
  end

  test "should get index" do
    get first_query_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_first_query_tag_url
    assert_response :success
  end

  test "should create first_query_tag" do
    assert_difference('FirstQueryTag.count') do
      post first_query_tags_url, params: { first_query_tag: { queryID: @first_query_tag.queryID, shotID: @first_query_tag.shotID, tagDesc: @first_query_tag.tagDesc, tagID: @first_query_tag.tagID, tagScore: @first_query_tag.tagScore } }
    end

    assert_redirected_to first_query_tag_url(FirstQueryTag.last)
  end

  test "should show first_query_tag" do
    get first_query_tag_url(@first_query_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_first_query_tag_url(@first_query_tag)
    assert_response :success
  end

  test "should update first_query_tag" do
    patch first_query_tag_url(@first_query_tag), params: { first_query_tag: { queryID: @first_query_tag.queryID, shotID: @first_query_tag.shotID, tagDesc: @first_query_tag.tagDesc, tagID: @first_query_tag.tagID, tagScore: @first_query_tag.tagScore } }
    assert_redirected_to first_query_tag_url(@first_query_tag)
  end

  test "should destroy first_query_tag" do
    assert_difference('FirstQueryTag.count', -1) do
      delete first_query_tag_url(@first_query_tag)
    end

    assert_redirected_to first_query_tags_url
  end
end
