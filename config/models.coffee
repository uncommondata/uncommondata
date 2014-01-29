# MODELS
# TODO - iterate over models dir and do this automatically

path = "../app/models"

require("#{path}/application/company")
require("#{path}/application/user")

# TODO - refactor me
global.AppUser = mongoose.model('application.user')
global.Company = mongoose.model('application.company')

global.metaSchemas = 
  User: require("#{path}/customer/user")()
  Device: require("#{path}/customer/device")()
  Event: require("#{path}/customer/event")()
