CatChat Client
==============

CatChat is a unique chat system that is for team based communications to
incorporate simple and cohesive communications for distributed teams.

## Notes

Packaging the Air App:

Compiling

``` sh
adt -prepare catchat.airi app.xml index.html ping.mp3 css/base.css css/layout.css css/skeleton.css css/app.css js/AIRAliases.js js/jquery-1.7.min.js js/sugar-1.1.1.min.js js/ember.min.js js/app.js js/models/ping.js js/models/message.js js/controllers/messages.js js/views/createMessage.js js/init.js icons/jackhq-16.png icons/jackhq-32.png  icons/jackhq-48.png icons/jackhq-128.png
```

Signing air app

``` sh
adt -sign -storetype pkcs12 -keystore newcert.p12 catchat.airi catchat.air
```