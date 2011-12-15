
  App.messagesController = Ember.ArrayProxy.create({
    content: [],
    createMessage: function(msg, cb) {
      msg = App.Message.create(msg);
      this.unshiftObject(msg);
      if (cb != null) return cb(null, msg);
    },
    post: function(msgBody) {
      var url;
      url = "http://catchat.wilbur.io/messages";
      return this.createMessage({
        author: App.messagesController.get('nick'),
        body: msgBody
      }, function(err, msg) {
        return msg.post(url);
      });
    },
    refresh: function() {
      return $.getJSON("http://catchat.wilbur.io/messages" + "?startkey=" + 10..secondBefore('now').iso(), function(chats) {
        var chat, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = chats.length; _i < _len; _i++) {
          chat = chats[_i];
          if (chat.author !== window.nick) {
            _results.push(App.messagesController.createMessage(chat, function(err, msg) {
              var reg;
              reg = new RegExp(window.nick + "|team");
              if (msg.get('body').match(reg)) return App.ping.play();
            }));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    },
    all: function() {
      return $.getJSON("http://catchat.wilbur.io/messages" + "?startkey=" + 1..dayBefore('now').iso(), function(chats) {
        var chat, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = chats.length; _i < _len; _i++) {
          chat = chats[_i];
          _results.push(App.messagesController.createMessage(chat));
        }
        return _results;
      });
    }
  });
