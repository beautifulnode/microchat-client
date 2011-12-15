# # Messages Controller
#
# The messages controller handles the posting of 
# new messages and the collection of incoming messages
#
#
App.messagesController = Ember.ArrayProxy.create
  content: []
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
    url = @get('url')
    @createMessage 
      author: App.messagesController.get('nick')
      body: msgBody
      (err, msg) -> 
        msg.post(url)
		
  # ## Load Method
  # 
  # The load method makes the ajax call to the server
  # to pull a group of messages based on a given day
  #
  load: (dt, cb) ->
	  $.getJSON @get("url") + "?startkey=" + dt.iso(), cb
  
  # ## Refresh Method
  #
  # The Refresh Method get any new message that 
  # occurred in the last 10 seconds, not real time
  # but pretty close :-)
  #
  refresh: ->
    @load (10).secondBefore('now'), (chats) ->  
      if chats? and chats.length > 0
        nick = App.messagesController.get('nick')
        
        for chat in chats
          if chat.author != nick
            App.messagesController.createMessage chat, (err, msg) -> 
              try
                reg = new RegExp(App.messagesController.get('nick') + "|team")
                App.ping.play() if msg.get('body').match reg
              catch error
                air.trace error

  # ## All Method
  #
  # This all method returns the last days worth of messages
  # Again there is no need to overwhelm you, awesome search
  # will be coming soon!
  #  
  all: ->
	  @load (1).dayBefore('now'), (chats) ->  
      App.messagesController.createMessage(chat) for chat in chats
