CatChat Client
==============

Simple Adobe Air Client to CatChat a RESTFul Chat Server.

## Notes

Packaging the Air App:

Compiling

``` sh
/Applications/AIRSDK/bin/adt -prepare catchat.airi app.xml index.html css/base.css css/layout.css css/skeleton.css js/AIRAliases.js js/coffee-script.js js/jquery-1.7.min.js js/sugar-1.1.1.min.js js/sproutcore.js
```

Signing air app

``` sh
/Applications/AIRSDK/bin/adt -sign -storetype pkcs12 -keystore newcert.p12 catchat.airi catchat.air
```