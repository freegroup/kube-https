'use strict'

const express = require('express')
const app = express()

const path = require('path')

// Constants
const PORT = 8080
const HOST = '0.0.0.0'

function nocache (req, res, next) {
  res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate')
  res.header('Expires', '-1')
  res.header('Pragma', 'no-cache')
  next()
}

app.use(express.static(path.join(__dirname, 'html')))


app.listen(PORT, HOST)
console.log(`Running on http://${HOST}:${PORT}`)
