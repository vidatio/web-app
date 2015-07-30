# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    "$rootScope"
    "ProgressService"
    "UserService"
    "$state"
    "$stateParams"
    ($scope, $rootScope, ProgressService, UserService, $state, $stateParams) ->
        $scope.progressService = ProgressService
        $scope.userService = UserService

        $scope.logout = ->
            UserService.logout()
            $state.go "home"

        $scope.locale = $stateParams.locale
        console.log "LOCALE", $scope.locale
]
