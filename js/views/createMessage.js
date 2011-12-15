
  App.CreateMessage = Ember.View.extend({
    click: function() {
      var msgBody;
      air.trace('Clicked...');
      msgBody = this.$('textarea').val();
      if ((msgBody != null) && msgBody.length > 0) {
        App.messagesController.post(msgBody);
      }
      return this.$('textarea').val('');
    }
  });
