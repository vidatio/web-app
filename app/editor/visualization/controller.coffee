# Visualization Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    ($scope, DataTable, Map) ->

        #Default settings - Works like scope.center, etc.
        $scope.center =
            lat: 47.723407
            lng: 13.086921
            zoom: 16

        # Watch on the dataset from the data table
        # and update markers on changed data
        $scope.$watch (->
            DataTable.dataset
        ), ((dataset) ->
            console.log 'data changed'
            Map.setMarkers dataset
        ), true

        $scope.markers = Map.markers
]
