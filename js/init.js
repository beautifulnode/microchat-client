(function() {
  var nick;

  window.nick = nick = prompt('Enter your username:');

  App.messagesController.set('nick', nick);

  $('title').text("CatChat - " + nick + " v0.5.0");

  App.messagesController.all();

  setInterval(App.messagesController.refresh, 10000);

  App.ping = App.Ping.create();

  App.ping.load();

  App.ping.play();

}).call(this);
