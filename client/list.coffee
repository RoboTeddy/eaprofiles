Template.list.users = -> Meteor.users.find(
  {"profile.isActive": true},
  {sort: {"profile.name": 1}}
)
