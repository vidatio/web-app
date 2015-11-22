"use strict"
app = angular.module "app.directives"

app.directive "progressOverlay", [->
    restrict: "E"
    templateUrl: "progress/progress-overlay.html"
    controller: "OverlayCtrl"
    replace: true
]
