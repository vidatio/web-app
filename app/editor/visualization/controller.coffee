# Visualization Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    ($scope, Table, Map) ->

        #Default settings - Works like scope.center, etc.
        $scope.center =
            lat: 47.723407
            lng: 13.086921
            zoom: 16

        $scope.geoJSON = Map.geoJSON
]
