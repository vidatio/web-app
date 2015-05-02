# Animals - App Controller
# ========================

"use strict"

app = angular.module "animals.controllers"

app.controller "AppCtrl", [
    "$scope"
    "$rootScope"
    "ProgressService"
    "UserService"
    "$state"
    ($scope, $rootScope, ProgressService, UserService, $state) ->
        $scope.progressService = ProgressService
        $scope.userService = UserService

        $scope.logout = ->
            UserService.logout()
            $state.go "home"
]
