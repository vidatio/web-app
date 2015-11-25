# Dataset-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    ($scope, $rootScope, $log) ->

        $scope.continueToEditor = ->
            $log.info "DatasetCtrl continueToEditor called"

]
