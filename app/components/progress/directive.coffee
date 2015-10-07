"use strict"
app = angular.module "app.directives"

app.directive "progressScreen", [
    ->
        return {
            restrict: "E"
            template: "<p>This is my message: {{ Overlay.message }}</p>"
            controller: "OverlayController"
            scope:
                message: "="
    }
]
