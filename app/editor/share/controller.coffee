# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    "ShareService"
    ($scope, Map, Share) ->
        $scope.shareVisualization = ->
            $map = $("#map")
            Share.mapToPNG $map
]
