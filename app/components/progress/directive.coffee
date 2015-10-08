"use strict"
app = angular.module "app.directives"

app.directive "progressScreen", [
    ->
        return {
            restrict: "EA"
            templateUrl: "progress/progress-overlay.html"
            controller: "OverlayController"
            scope:
                message: "="
        }
]
