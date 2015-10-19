"use strict"
app = angular.module "app.directives"

app.directive "progressOverlay", [
    ->
        return {
            restrict: "EA"
            templateUrl: "progress/progress-overlay.html"
            controller: "OverlayController"
            replace: true
        }
]
