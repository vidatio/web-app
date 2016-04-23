###!
# Vidatio
# @version v0.0.48
# @link https://vidatio.com
# @copyright 2014-2016 Vidatio
#
# University of Applied Science
# MultiMediaTechnology Master
#
# Commercial use without owners’ permission is prohibited
###

# App Init-Dependencies
# this makes sure, that these modules are available and must not be declared
# in each service or whatever

angular.module "app.filters", []
angular.module "app.services", []
angular.module "app.factories", []
angular.module "app.controllers", []
angular.module "app.directives", []

# Namespace for standalone Javascripts in the App
window.vidatio or= {}
