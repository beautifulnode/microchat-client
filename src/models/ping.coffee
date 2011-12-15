# # Ping
#
# Ping is a model that controls the management of the 
# ping sound effect when a message is put in the chat 
# window with the current users nick or team
#
#
App.Ping = Ember.Object.extend
  name: "/ping.mp3"
  sound: null
  # # Play Method
  #
  # no params
  #
  # This method when called will attempt to play the 
  # sound file if it is correctly set to an attibute on the
  # current Ping Model Instance
  play: -> @get('sound').play() if @get('sound')?
  # # Load Method
  #
  # no params
  #
  # The load method performs the process of loading the sound file
  # into the application, this process should only have to occur
  # one time and then play many.
  load: ->
    try        
      s = new air.Sound()
      s.addEventListener air.Event.COMPLETE, (event) => 
        @set('sound', event.target)
        event.target.play()     
      req = new air.URLRequest @get('name')
      s.load(req)

    catch error
      air.trace error
    
