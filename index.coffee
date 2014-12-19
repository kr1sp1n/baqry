express = require 'express'
app = express()
bodyParser = require 'body-parser'

app.set 'port', (process.env.PORT || 3000)

server = null
io = null

options = {}
app.use express.static 'public', options
app.use bodyParser.json()

event_map =
  'alert':
    'module': 'window'
    'function': 'alert'

app.get '/', (req, res)->
  res.sendFile "#{__dirname}/public/index.html"

app.get '/remote', (req, res)->
  res.sendFile "#{__dirname}/public/remote.html"

app.post '/msg', (req, res)->
  io.emit 'chat message', req.body.title
  res.json req.body

server = app.listen app.get('port'), ->
  host = server.address().address
  port = server.address().port
  io = require('socket.io')(server)
  io.on 'connection', (socket)->

    console.log "client #{socket.id} connected"

    socket.on 'chat message', (msg)->
      socket.broadcast.emit 'chat message', msg

  app.set 'endpoint', "http://#{host}:#{port}"
  console.log 'Example app listening at http://%s:%s', host, port
