"use strict"

app = angular.module "app.directives"

app.directive "visualization", [
    "MapService"
    "VisualizationService"
    (Map, Visualization) ->
        templateUrl: "components/visualization/visualization.html"
        replace: true
        restrict: "E"
        link: ($scope) ->
            $scope.options = Visualization.options
            $scope.geojson = Map.leaflet
]
