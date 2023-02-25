def json_status(code, *reason)
  status code
  {
    :status => code,
    :reason => reason[0]
  }.to_json
end
