
  App.messagesController = Ember.ArrayProxy.create({
    content: [],
    url: "http://catchat.wilbur.io/messages",
    createMessage: function(msg, cb) {
      msg = App.Message.create(msg);
      this.unshiftObject(msg);
      if (cb != null) return cb(null, msg);
    },
    post: function(msgBody) {
      var url;
      url = this.url;
      if (msgBody.match(/\!\[(.*)\]/)) {
        msgBody = msgBody.replace(/\!\[/g, '<img src=\"http://').replace(/\]/g, '.jpg.to\" />');
      }
      return this.createMessage({
        author: App.messagesController.get('nick'),
        body: msgBody
      }, function(err, msg) {
        msg.post(url);
        return $('textarea').focus();
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
      return $.getJSON(this.url + "?startkey=" + 1..dayBefore('now').iso(), function(chats) {
        var chat, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = chats.length; _i < _len; _i++) {
          chat = chats[_i];
          _results.push(App.messagesController.createMessage(chat));
        }
        return _results;
      });
    },
    pop: function() {
      return setTimeout((function() {
        var new_item;
        new_item = $('ul li').first();
        new_item.css('background', 'lightyellow');
        new_item.slideFadeToggle();
        return setTimeout((function() {
          new_item.slideFadeToggle();
          return setTimeout((function() {
            return new_item.css('background', '#fff');
          }), 500);
        }), 500);
      }), 500);
    }
  });
