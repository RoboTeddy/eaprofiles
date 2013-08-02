updateInkBlob = (inkBlob) ->
  Meteor.users.update Meteor.userId(), $set: {"profile.inkBlob": inkBlob}

Template.form.profile = -> Meteor.user().profile

Template.form.email = ->
  Meteor.user()?.profile?.email or _.first(Meteor.user().emails)?.address

Template.form.photoUrl = (profile, width, height) ->
  console.log(profile, width, height)
  url = profile?.inkBlob?.url
  return url + "/convert?width=#{width}&height=#{height}" if url
  return '/no-photo.png'

Template.form.events
  'click .js-pick-photo': (e) ->
    filepicker.setKey settings.filepicker.key
    filepicker.pickAndStore(
      {mimetype: "image/*", multiple: false, services: settings.filepicker.services},
      {location: "S3"},
      (inkBlobs) -> updateInkBlob _.first inkBlobs
    )

  'click .js-update-profile': (e) ->
    e.preventDefault()
    Meteor.users.update(
      Meteor.userId(),
      $set:
        "profile.name": $('#name').val()
        "profile.email": $('#email').val()
        "profile.skype": $('#skype').val()
        "profile.doingNow": $('#doingNow').val()
        "profile.bio": $('#bio').val()
        "profile.areasOfInterest": $('#areasOfInterest').val()
        "profile.areasOfExpertise": $('#areasOfExpertise').val()
        "profile.isActive": true
        "profile.contactEncouragement": $('#contactEncouragement').val()
    )

  'click .js-deactivate-profile': (e) ->
    e.preventDefault()
    Meteor.users.update Meteor.userId(), $set: {"profile.isActive": false}

Template.form.rendered = ->
  $(@find("#location")).geocomplete
    map: ".map_canvas"
    types: ["geocode", "establishment"]
  .trigger("geocode")