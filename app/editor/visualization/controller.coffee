# Visualization Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    ($scope, Table, Map) ->
        $scope.center =
            lat: 47.723407
            lng: 13.086921
            zoom: 16

        $scope.markers = Map.markers
]
