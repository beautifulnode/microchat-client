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
        $('textarea').focus()
		
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
            #App.messagesController.pop()
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
      App.messagesController.createMessage(chat) for chat in chats

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
    