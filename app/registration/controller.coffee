"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    ($scope, UserFactory) ->
        $scope.register = ->
            UserFactory.save {"mail": user.mail, "name": user.name, "password": user.password }
]
