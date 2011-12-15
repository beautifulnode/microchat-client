
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
