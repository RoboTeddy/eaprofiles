settings =
  filepicker:
    services: [
      "COMPUTER", "DROPBOX", "FACEBOOK", "FLICKR",
      "GOOGLE_DRIVE", "SKYDRIVE", "PICASA", "BOX", "EVERNOTE"
    ]
    key: "AzDgfqUNR2BwRwA00z8AQz"


if Meteor.isClient
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
          "profile.isActive": true
      )

    'click .js-deactivate-profile': (e) ->
      e.preventDefault()
      Meteor.users.update Meteor.userId(), $set: {"profile.isActive": false}

  Template.list.users = -> Meteor.users.find(
    {"profile.isActive": true},
    {sort: {"profile.name": 1}}
  )

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
