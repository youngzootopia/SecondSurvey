require 'test_helper'

class ShotInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shot_info = shot_infos(:one)
  end

  test "should get index" do
    get shot_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_shot_info_url
    assert_response :success
  end

  test "should create shot_info" do
    assert_difference('ShotInfo.count') do
      post shot_infos_url, params: { shot_info: { CID: @shot_info.CID, EndFrame: @shot_info.EndFrame, ShotID: @shot_info.ShotID, ShotNum: @shot_info.ShotNum, StartFrame: @shot_info.StartFrame, ThumbURL: @shot_info.ThumbURL } }
    end

    assert_redirected_to shot_info_url(ShotInfo.last)
  end

  test "should show shot_info" do
    get shot_info_url(@shot_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_shot_info_url(@shot_info)
    assert_response :success
  end

  test "should update shot_info" do
    patch shot_info_url(@shot_info), params: { shot_info: { CID: @shot_info.CID, EndFrame: @shot_info.EndFrame, ShotID: @shot_info.ShotID, ShotNum: @shot_info.ShotNum, StartFrame: @shot_info.StartFrame, ThumbURL: @shot_info.ThumbURL } }
    assert_redirected_to shot_info_url(@shot_info)
  end

  test "should destroy shot_info" do
    assert_difference('ShotInfo.count', -1) do
      delete shot_info_url(@shot_info)
    end

    assert_redirected_to shot_infos_url
  end
end
