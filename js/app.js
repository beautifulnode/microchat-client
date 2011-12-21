(function() {
  var App, nick;

  window.App = App = Ember.Application.create();

  App.Ping = Ember.Object.extend({
    name: "/ping.mp3",
    sound: null,
    play: function() {
      if (this.get('sound') != null) return this.get('sound').play();
    },
    load: function() {
      var req, s;
      var _this = this;
      try {
        s = new air.Sound();
        s.addEventListener(air.Event.COMPLETE, function(event) {
          _this.set('sound', event.target);
          return event.target.play();
        });
        req = new air.URLRequest(this.get('name'));
        return s.load(req);
      } catch (error) {
        return air.trace(error);
      }
    }
  });

  App.Message = Ember.Object.extend({
    fmtCreated: (function() {
      return Date.create(this.get('dateCreated')).format('{Weekday} {12hr}:{mm}{tt}');
    }).property('dateCreated'),
    post: function(url) {
      var loader, msg, request;
      msg = {
        author: this.get('author'),
        body: this.get('body')
      };
      request = new air.URLRequest(url);
      request.method = air.URLRequestMethod.POST;
      request.contentType = "application/json";
      request.data = JSON.stringify(msg);
      loader = new air.URLLoader();
      loader.load(request);
      return msg.dateCreated = Date.create('now');
    }
  });

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
              App.messagesController.pop();
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

  App.CreateMessage = Ember.View.extend({
    click: function() {
      var text;
      text = $('textarea').val();
      if ((text != null) && text.length > 0) {
        return MrClean.clean(text, function(err, msgBody) {
          App.messagesController.post(msgBody);
          return $('textarea').val('');
        });
      }
    }
  });

  window.nick = nick = prompt('Enter your username:');

  App.messagesController.set('nick', nick);

  $('title').text("CatChat - " + nick + " v0.4.4");

  App.messagesController.all();

  setInterval(App.messagesController.refresh, 10000);

  App.ping = App.Ping.create();

  App.ping.load();

  App.ping.play();

}).call(this);
