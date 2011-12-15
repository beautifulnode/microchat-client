
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
