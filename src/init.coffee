# Init App
# Setup Title
$('title').text("CatChat - #{nick} v0.4.0")

# Get Nick Name
nick = prompt 'Enter your username:'
App.messagesController.set('nick', nick)

# Origin
App.messagesController.set 'url', "http://catchat.wilbur.io/messages"

# load a full days worth of messages.
App.messagesController.all()

# init ping
App.ping = App.Ping.create()
App.ping.load()


# init timer
setInterval App.messagesController.refresh, 10000
