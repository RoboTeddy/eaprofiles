Meteor.Router.add
  '/': 'list'
  '/me': 'form'
  '/map': 'map'
  '/profile/:id':
    as: 'profile'
    to: (id) ->
      Session.set('activeUserId', id)
      'profile'

# Direct to form on login, and to list on logout
hasSkipped = false
Meteor.autorun ->
  user = Meteor.user() # hack: always register dep
  if not hasSkipped
    hasSkipped = true
    return
  Meteor.Router.to(if user then 'form' else 'list')
