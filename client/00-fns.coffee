# I dunno how to intelligently export things in Meteor yet. Derp.
window.fns =
  getPhotoURL: (profile, width, height) ->
    url = profile?.inkBlob?.url
    return url + "/convert?width=#{width}&height=#{height}" if url
    return "/no-photo.png"
