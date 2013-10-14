Template.map.rendered = ->
  options =
    center: new google.maps.LatLng(0,0)
    zoom: 2
    mapTypeId: google.maps.MapTypeId.ROADMAP #TODO
  map = new google.maps.Map($("#bigmap_canvas")[0], options)
  Meteor.users.find({"profile.isActive": true}).forEach (user) =>
    {lat, lng} = user.profile
    lat = parseFloat(lat)
    lng = parseFloat(lng)
    return if isNaN(lat) || isNaN(lng)
    marker = new google.maps.Marker
      title: user.profile.name
      position: new google.maps.LatLng(lat, lng)
    marker.setMap(map)

    info = new google.maps.InfoWindow
      content: """<a href="/profile/#{user._id}">#{user.profile.name}</a>"""
    
    google.maps.event.addListener marker, 'click', =>
      info.open(map, marker)
