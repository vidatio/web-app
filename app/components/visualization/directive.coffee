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
            heightParent = element.parent().height()

            # Resizing the visualizations
            # using setTimeout to use only to the last resize action of the user
            # and create the viz only when the parent has changed its size
            id = null
            onWindowResizeCallback = ->
                currentWidthParent = element.parent().width()
                currentHeightParent = element.parent().height()

                unless $(element).is(":visible") and (currentWidthParent is widthParent and currentHeightParent is heightParent)
                    widthParent = currentWidthParent
                    heightParent = currentHeightParent

                    clearTimeout id
                    id = setTimeout ->
                        Visualization.create()
                    , 250

            # resize event only should be fired if user is currently in editor
            window.angular.element($window).on "resize", $scope.$apply, onWindowResizeCallback

            # resize watcher has to be removed when editor is leaved
            $scope.$on "$destroy", ->
                window.angular.element($window).off "resize", onWindowResizeCallback
]
