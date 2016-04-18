"use strict"

app = angular.module("app.controllers")

app.controller "ProgressCtrl", [
    "$scope"
    "ProgressService"
    ($scope, Progress) ->
        $scope.progress = Progress
]
