require 'test_helper'

class ClistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @clist = clists(:one)
  end

  test "should get index" do
    get clists_url
    assert_response :success
  end

  test "should get new" do
    get new_clist_url
    assert_response :success
  end

  test "should create clist" do
    assert_difference('Clist.count') do
      post clists_url, params: { clist: { CID: @clist.CID, Category: @clist.Category, EpisodeNum: @clist.EpisodeNum, FPS: @clist.FPS, LastSavedDateTime: @clist.LastSavedDateTime, ProgramName: @clist.ProgramName, ProgramNameKor: @clist.ProgramNameKor, RegisterDateTime: @clist.RegisterDateTime, TagStatus: @clist.TagStatus, User: @clist.User, VideoFileName: @clist.VideoFileName, VideoThumb: @clist.VideoThumb, VideoURL: @clist.VideoURL } }
    end

    assert_redirected_to clist_url(Clist.last)
  end

  test "should show clist" do
    get clist_url(@clist)
    assert_response :success
  end

  test "should get edit" do
    get edit_clist_url(@clist)
    assert_response :success
  end

  test "should update clist" do
    patch clist_url(@clist), params: { clist: { CID: @clist.CID, Category: @clist.Category, EpisodeNum: @clist.EpisodeNum, FPS: @clist.FPS, LastSavedDateTime: @clist.LastSavedDateTime, ProgramName: @clist.ProgramName, ProgramNameKor: @clist.ProgramNameKor, RegisterDateTime: @clist.RegisterDateTime, TagStatus: @clist.TagStatus, User: @clist.User, VideoFileName: @clist.VideoFileName, VideoThumb: @clist.VideoThumb, VideoURL: @clist.VideoURL } }
    assert_redirected_to clist_url(@clist)
  end

  test "should destroy clist" do
    assert_difference('Clist.count', -1) do
      delete clist_url(@clist)
    end

    assert_redirected_to clists_url
  end
end
