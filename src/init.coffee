# Init App
# Get Nick Name
window.nick = nick = prompt 'Enter your username:'
App.messagesController.set('nick', nick)

# Setup Title
$('title').text("CatChat - #{nick} v0.4.1")

# load a full days worth of messages.
App.messagesController.all()

# init timer
setInterval App.messagesController.refresh, 10000

# # init ping
App.ping = App.Ping.create()
App.ping.load()

App.ping.play()