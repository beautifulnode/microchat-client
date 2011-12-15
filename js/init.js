(function() {
  var nick;

  $('title').text("CatChat - " + nick + " v0.4.0");

  nick = prompt('Enter your username:');

  App.messagesController.set('nick', nick);

  App.messagesController.set('url', "http://catchat.wilbur.io/messages");

  App.messagesController.all();

  App.ping = App.Ping.create();

  App.ping.load();

  setInterval(App.messagesController.refresh, 10000);

}).call(this);
