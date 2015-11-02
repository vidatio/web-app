"use strict"

app = angular.module("app.controllers")

app.controller "OverlayCtrl", [
    "$scope"
    "ProgressOverlayService"
    ($scope, ProgressOverlay) ->

        $scope.overlay = ProgressOverlay

]
