"use strict"

app = angular.module("app.controllers")

app.controller "OverlayController", [
    "$scope"
    "ProgressOverlayService"
    ($scope, ProgressOverlay) ->

        $scope.Overlay = ProgressOverlay
#        console.log("OverlayController")
#        $scope.setMessage = (msg) ->
#            console.log("MESSAGE", msg)
#            $scope.message = msg
#
#        $scope.setMessage("TEST!!!")
]
