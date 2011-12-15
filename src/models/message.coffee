# # Message Model
#
# The Message Model is the core of the application.
# It maintains the structure of each timeline message
# and properly manages the post of the message
#
# Note: in the future we should proxy out the post 
# message using a Mixin, so that if it is running on 
# air or phonegap the post api can be swapped.

App.Message = Ember.Object.extend
  fmtCreated: ( ->
    Date.create(@get('dateCreated')).format('{Weekday} {12hr}:{mm}{tt}')
  ).property('dateCreated')
  # # Post Method
  # 
  # no params
  # 
  # This method will take the current method instance and post
  # it to the server, based on the set url attribute.
  post: (url) ->
    msg = author: @get('author'), body: @get('body')
    
    request = new air.URLRequest(url)
    request.method = air.URLRequestMethod.POST
    request.contentType = "application/json"
    request.data = JSON.stringify(msg)

    loader = new air.URLLoader()
    loader.load(request)
    
    msg.dateCreated = Date.create('now')

