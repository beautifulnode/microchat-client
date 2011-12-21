# # Cat Chat
#
# EmberJs Client App running on Adobe Air
#

# setup Ember App
window.App = App = Ember.Application.create()

# # Ping
#
# Ping is a model that controls the management of the 
# ping sound effect when a message is put in the chat 
# window with the current users nick or team
#
#
App.Ping = Ember.Object.extend
  name: "/ping.mp3"
  sound: null
  # # Play Method
  #
  # no params
  #
  # This method when called will attempt to play the 
  # sound file if it is correctly set to an attibute on the
  # current Ping Model Instance
  play: -> @get('sound').play() if @get('sound')?
  # # Load Method
  #
  # no params
  #
  # The load method performs the process of loading the sound file
  # into the application, this process should only have to occur
  # one time and then play many.
  load: ->
    try        
      s = new air.Sound()
      s.addEventListener air.Event.COMPLETE, (event) => 
        @set('sound', event.target)
        event.target.play()     
      req = new air.URLRequest @get('name')
      s.load(req)

    catch error
      air.trace error
    

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

# # Messages Controller
#
# The messages controller handles the posting of 
# new messages and the collection of incoming messages
#
#
App.messagesController = Ember.ArrayProxy.create
  content: []
  url: "http://catchat.wilbur.io/messages"
  # ## Create Message Method
  #
  # The createMessage method generates a new message and pops it 
  # in the content array.  It also returns a callback incase
  # any additional functionality is required
  createMessage: (msg, cb) -> 
    msg = App.Message.create(msg)
    @.unshiftObject msg
    cb(null, msg) if cb?

  # ## Post Method
  # 
  # This method is the hook from the click event
  # on the CreateMessage view, it creates the message
  # and then posts the message to the server.
  #
  post: (msgBody) ->
    url = @url
    msgBody = msgBody.replace(/\!\[/g, '<img src=\"http://').replace(/\]/g, '.jpg.to\" />') if msgBody.match /\!\[(.*)\]/
        
    @createMessage 
      author: App.messagesController.get('nick')
      body: msgBody
      (err, msg) -> 
        msg.post(url)

  # ## Refresh Method
  #
  # The Refresh Method get any new message that 
  # occurred in the last 10 seconds, not real time
  # but pretty close :-)
  #
  refresh: ->
    $.getJSON "http://catchat.wilbur.io/messages" + "?startkey=" + (10).secondBefore('now').iso(), (chats) ->  
      for chat in chats
        if chat.author != window.nick
          App.messagesController.createMessage chat, (err, msg) -> 
            App.messagesController.pop()
            reg = new RegExp(window.nick + "|team")
            App.ping.play() if msg.get('body').match reg

  # ## All Method
  #
  # This all method returns the last days worth of messages
  # Again there is no need to overwhelm you, awesome search
  # will be coming soon!
  #  
  all: ->
	  $.getJSON @url + "?startkey=" + (1).dayBefore('now').iso(), (chats) ->  
      for chat in chats
        App.messagesController.createMessage(chat) 

  pop: ->
    setTimeout ( -> 
      new_item = $('ul li').first()
      new_item.css 'background', 'lightyellow'
      new_item.slideFadeToggle()
      setTimeout ( ->
        new_item.slideFadeToggle()
        setTimeout ( -> 
          new_item.css 'background', '#fff'
        ), 500              
      ), 500
    ), 500

# # CreateMessage View
#
# This view encapuslates the textarea and the chat button
# When clicked we get the content of the text box and then
# call the post message on the message controller.

App.CreateMessage = Ember.View.extend 
  click: ->    
    text = $('textarea').val()
    if text? and text.length > 0
      MrClean.clean text, (err, msgBody) ->
        App.messagesController.post msgBody 
        $('textarea').val('')

# Init App
# Get Nick Name
window.nick = nick = prompt 'Enter your username:'
App.messagesController.set('nick', nick)

# Setup Title
$('title').text("CatChat - #{nick} v0.4.5")

# load a full days worth of messages.
App.messagesController.all()

# init timer
setInterval App.messagesController.refresh, 10000

# # init ping
App.ping = App.Ping.create()
App.ping.load()

App.ping.play()
