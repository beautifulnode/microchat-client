fs            = require 'fs'
{print}       = require 'sys'
{spawn, exec} = require 'child_process'
ask = require 'ask'

# ANSI Terminal Colors
bold = '\033[0;1m'
green = '\033[0;32m'
reset = '\033[0m'
red = '\033[0;31m'

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  options = ['-c', '-o', 'js', 'src']
  options.unshift '-w' if watch

  coffee = spawn 'coffee', options
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> log data.toString(), red
  coffee.on 'exit', (status) -> callback?() if status is 0

spec = (callback) ->
  spec = spawn 'mocha'
  spec.stdout.on 'data', (data) -> print data.toString()
  spec.stderr.on 'data', (data) -> log data.toString(), red
  spec.on 'exit', (status) -> callback?() if status is 0


task 'docs', 'Generate annotated source code with Docco', ->
  files = [
    "src/app.coffee"
    "src/models/ping.coffee"
    "src/models/message.coffee"
    "src/controllers/messages.coffee"
    "src/views/createMessage.coffee"
  ]
  docco = spawn 'docco', files
  docco.stdout.on 'data', (data) -> print data.toString()
  docco.stderr.on 'data', (data) -> log data.toString(), red
  docco.on 'exit', (status) -> callback?() if status is 0


task 'build', ->
  build -> log ":)", green

task 'spec', 'Run Jasmine-Node', ->
  build -> spec -> log ":)", green
  
task 'create', 'create airi file', ->
  airi = spawn 'adt', [
    "-prepare" 
    "catchat.airi" 
    "app.xml" 
    "index.html" 
    "ping.mp3" 
    "css/base.css" 
    "css/layout.css" 
    "css/skeleton.css"
    "icons/jackhq-16.png" 
    "icons/jackhq-32.png"  
    "icons/jackhq-48.png" 
    "icons/jackhq-128.png" 
    "js/AIRAliases.js" 
    "js/jquery-1.7.min.js" 
    "js/sugar-1.1.1.min.js"
    "js/ember.min.js" 
    "js/app.js" 
    "js/models/ping.js" 
    "js/models/message.js" 
    "js/views/createMessage.js" 
    "js/init.js" 
    "js/controllers/messages.js" 
  ]
  airi.stdout.on 'data', (data) -> print data.toString()
  airi.stderr.on 'data', (data) -> log data.toString(), red
  airi.on 'exit', (status) -> callback?() if status is 0

task 'sign', 'sign air file', ->
  ask "password", /.+/, (answer) ->
    air = spawn "adt", [
      "-sign" 
      "-storetype" 
      "pkcs12" 
      "-keystore" 
      "newcert.p12"
      "-storepass"
      answer  
      "catchat.airi" 
      "catchat.air"
    ]
    air.stdout.on 'data', (data) -> print data.toString()
    air.stderr.on 'data', (data) -> log data.toString(), red
    air.on 'exit', (status) -> callback?() if status is 0
  
  