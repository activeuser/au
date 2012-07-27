WebSocketServer = require('ws').Server
wss = new WebSocketServer port: 8080

connected = {}

wss.on 'connection', (ws) ->
  id = ws.upgradeReq.client._idleStart
  connected[id] = ws

  ws.on 'message', (message) ->
    console.log 'received: %s', message
    ws.send 'something'

  ws.on 'close', ->
    delete connected[id]

exports.reload = (file) ->
  for id, ws of connected
    ws.send JSON.stringify
      type: 'reload'
