json.array!(@videos) do |video|
  json.extract! video, :id, :name, :description, :thumb, :date, :vid
  json.url video_url(video, format: :json)
end
