global.mongoose = require('mongoose')
url = process.env.MONGO_URL or "mongodb://localhost"
mongoose.connect(url, {db: {native_parser: true}})
