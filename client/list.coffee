Template.list.users = -> Meteor.users.find(
  {"profile.isActive": true},
  {sort: {"profile.name": 1}}
)

Template.list.getPhotoURL = window.fns.getPhotoURL