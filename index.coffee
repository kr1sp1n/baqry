express = require 'express'
app = express()


options = {}
app.use express.static 'public', options

event_map =
  'alert':
    'module': 'window'
    'function': 'alert'

app.get '/', (req, res)->
  res.sendFile "#{__dirname}/public/index.html"

app.get '/remote', (req, res)->
  res.sendFile "#{__dirname}/public/remote.html"

server = app.listen 3000, ->
  host = server.address().address
  port = server.address().port
  io = require('socket.io')(server)
  io.on 'connection', (socket)->

    console.log "client #{socket.id} connected"

    socket.on 'chat message', (msg)->
      socket.broadcast.emit 'chat message', msg


  app.set 'endpoint', "http://#{host}:#{port}"
  console.log 'Example app listening at http://%s:%s', host, port
