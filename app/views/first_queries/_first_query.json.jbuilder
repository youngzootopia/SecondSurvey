json.extract! first_query, :id, :sUserID, :queryID, :query, :created_at, :updated_at
json.url first_query_url(first_query, format: :json)