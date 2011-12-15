# # CreateMessage View
#
# This view encapuslates the textarea and the chat button
# When clicked we get the content of the text box and then
# call the post message on the message controller.

App.CreateMessage = Ember.View.extend
  click: ->
    air.trace 'Clicked...'
    msgBody = @$('textarea').val()
    App.messagesController.post msgBody if msgBody? and msgBody.length > 0
    @$('textarea').val('')
