(function() {

  App.CreateMessage = Ember.View.extend({
    click: function() {
      var msgBody;
      msgBody = $('textarea').val();
      if ((msgBody != null) && msgBody.length > 0) {
        App.messagesController.post(msgBody);
      }
      return $('textarea').val('');
    }
  });

}).call(this);
