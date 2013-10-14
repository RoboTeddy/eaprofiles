updateInkBlob = (inkBlob) ->
  Meteor.users.update Meteor.userId(), $set: {"profile.inkBlob": inkBlob}

Template.form.profile = -> Meteor.user().profile

Template.form.email = ->
  Meteor.user()?.profile?.email or _.first(Meteor.user().emails)?.address

Template.form.getPhotoURL = window.fns.getPhotoURL

FORM_FIELDS = { # fieldName: inputId
  "name"
  "email"
  "doingNow"
  "bio"
  "areasOfInterest"
  "areasOfExpertise"
  "canContact"
  "contactEncouragement"
  "canHost"
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

    getTypedValue = (input) ->
      $input = $(input)
      if $input.is('[type=checkbox]') then $input.is(':checked') else
        $input.val()

    for fieldName of FORM_FIELDS
      inputId = FORM_FIELDS[fieldName]
      set["profile.#{fieldName}"] = getTypedValue($("##{inputId}"))
    set["profile.isActive"] = true
    Meteor.users.update(Meteor.userId(), {$set: set})
    Meteor.Router.to('profile', Meteor.userId())

  'click .js-deactivate-profile': (e) ->
    e.preventDefault()
    Meteor.users.update Meteor.userId(), $set: {"profile.isActive": false}
    Meteor.Router.to('list')

Template.form.rendered = ->
  $(@find("#location")).geocomplete
    map: ".map_canvas"
    details: "#geocomplete_info"
    types: ["geocode", "establishment"]
  .trigger("geocode")
