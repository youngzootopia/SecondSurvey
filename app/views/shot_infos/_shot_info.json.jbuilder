json.extract! shot_info, :id, :ShotID, :ShotNum, :StartFrame, :EndFrame, :ThumbURL, :CID, :created_at, :updated_at
json.url shot_info_url(shot_info, format: :json)