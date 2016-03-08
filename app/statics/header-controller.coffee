# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "DataService"
    "$log"
    "ngToast"
    "$translate"
    ($scope, $rootScope, $timeout, Data, $log, ngToast, $translate) ->

]
