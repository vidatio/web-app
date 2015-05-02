"use strict"

app = angular.module "animals.controllers"

app.controller "UserCtrl", [
    "$scope"
    "UserService"
    ($scope, UserService) ->

        $scope.UserService = UserService

        $scope.alerts =
            name: []
            password: []



]

