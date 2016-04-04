"use strict"

app = angular.module "app.directives"

app.directive "visualization", [
    "MapService"
    "VisualizationService"
    "$window"
    (Map, Visualization, $window) ->
        templateUrl: "components/visualization/visualization.html"
        replace: true
        restrict: "E"
        link: ($scope, element) ->
            $scope.options = Visualization.options
            $scope.geojson = Map.leaflet

            widthParent = element.parent().width()

            # Resizing the visualizations
            # using setTimeout to use only to the last resize action of the user
            # and create the viz only when the parent has changed its size
            id = null
            onWindowResizeCallback = ->
                currentWidthParent = element.parent().width()

                unless $(element).is(":visible") and currentWidthParent is widthParent
                    widthParent = currentWidthParent

                    clearTimeout id
                    id = setTimeout ->
                        Visualization.create()
                    , 250

            # resize event only should be fired if user is currently in editor
            window.angular.element($window).on 'resize', $scope.$apply, onWindowResizeCallback

            # resize watcher has to be removed when editor is leaved
            $scope.$on '$destroy', ->
                window.angular.element($window).off 'resize', onWindowResizeCallback
]
