updateInkBlob = (inkBlob) ->
  Meteor.users.update Meteor.userId(), $set: {"profile.inkBlob": inkBlob}

Template.form.profile = -> Meteor.user().profile

Template.form.email = ->
  Meteor.user()?.profile?.email or _.first(Meteor.user().emails)?.address

Template.form.photoUrl = window.fns.getPhotoURL

FORM_FIELDS = { # fieldname: inputid
  "name"
  "email"
  "skype"
  "doingNow"
  "bio"
  "areasOfInterest"
  "areasOfExpertise"
  "contact"
  "contactEncouragement"
  "host"
  "hostEncouragement"
  "location"
  "lat"
  "lng"
}

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
    set = {}
    for fieldname of FORM_FIELDS
      inputid = FORM_FIELDS[fieldname]
      set["profile.#{fieldname}"] = $("##{inputid}").val()
    set["profile.isActive"] = true
    console.log set
    Meteor.users.update(Meteor.userId(), { $set: set })

  'click .js-deactivate-profile': (e) ->
    e.preventDefault()
    Meteor.users.update Meteor.userId(), $set: {"profile.isActive": false}

Template.form.rendered = ->
  $(@find("#location")).geocomplete
    map: ".map_canvas"
    details: "#geocomplete_info"
    types: ["geocode", "establishment"]
  .trigger("geocode")