Template.list.users = ->
  query =
    'profile.isActive': true
    'profile.name': $ne: ''
    'profile.doingNow': $ne: ''

  Meteor.users.find(query, {sort: {'profile.name': 1}})

Template.list.getPhotoURL = window.fns.getPhotoURL


Template.list.events
  'click .profile': -> Meteor.Router.to('profile', @_id)
