
  App.messagesController = Ember.ArrayProxy.create({
    content: [],
    createMessage: function(msg, cb) {
      msg = App.Message.create(msg);
      this.unshiftObject(msg);
      if (cb != null) return cb(null, msg);
    },
    post: function(msgBody) {
      var url;
      url = this.get('url');
      return this.createMessage({
        author: App.messagesController.get('nick'),
        body: msgBody
      }, function(err, msg) {
        return msg.post(url);
      });
    },
    load: function(dt, cb) {
      return $.getJSON(this.get("url") + "?startkey=" + dt.iso(), cb);
    },
    refresh: function() {
      return this.load(10..secondBefore('now'), function(chats) {
        var chat, nick, _i, _len, _results;
        if ((chats != null) && chats.length > 0) {
          nick = App.messagesController.get('nick');
          _results = [];
          for (_i = 0, _len = chats.length; _i < _len; _i++) {
            chat = chats[_i];
            if (chat.author !== nick) {
              _results.push(App.messagesController.createMessage(chat, function(err, msg) {
                var reg;
                try {
                  reg = new RegExp(App.messagesController.get('nick') + "|team");
                  if (msg.get('body').match(reg)) return App.ping.play();
                } catch (error) {
                  return air.trace(error);
                }
              }));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        }
      });
    },
    all: function() {
      return this.load(1..dayBefore('now'), function(chats) {
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
