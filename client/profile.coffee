Template.profile.profile = ->
  Meteor.users.findOne(Session.get('activeUserId')).profile

Template.profile.getPhotoURL = window.fns.getPhotoURL
