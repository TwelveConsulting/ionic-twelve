
http = require('http')
basic_auth = require('basic-auth')
express = require('express')
app = express()

auth = (req, res, next)->
  unauthorized = (res)->
    res.set('WWW-Authenticate', 'Basic realm=Authorization Required')
    return res.send(401)
  return next() unless process.env.LOGIN? && process.env.PASSWORD?
  user = basic_auth(req)
  return unauthorized(res) if !user || !user.name || !user.pass
  if (user.name == process.env.LOGIN && user.pass == process.env.PASSWORD)
    return next()
  unauthorized(res)


app.use(auth)
app.use(express.static('www'))

app.all '*', (req, res, next)->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  next()

app.set('port', process.env.PORT || 5000)

app.listen app.get('port'),  ()->
  console.log('Express server listening on port ' + app.get('port'))
