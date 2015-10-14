"use strict"

app = angular.module("app.controllers")

app.controller "OverlayController", [
    "$scope"
    "ProgressOverlayService"
    ($scope, ProgressOverlay) ->

        $scope.overlay = ProgressOverlay
]
