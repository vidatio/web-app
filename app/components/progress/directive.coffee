"use strict"
app = angular.module "app.directives"

app.directive "progressOverlay", [
    ->
        return {
            restrict: "E"
            templateUrl: "progress/progress-overlay.html"
            controller: "OverlayCtrl"
            replace: true
        }

]
