# User Controller
# ===============

"use strict"

app = angular.module "app.controllers"

app.controller "UserCtrl", [
    "$scope"
    "UserService"
    ($scope, UserService) ->

        $scope.UserService = UserService

        $scope.alerts =
            name: []
            password: []



]

