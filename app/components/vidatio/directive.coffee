"use strict"

app = angular.module "app.directives"

app.directive "vidatioOverview", [ ->
    restrict: "E"
    templateUrl: "components/vidatio/directive.html"
    replace: false
    scope:
        vidatio: "="
        expand: "@"
    controller: "VidatioOverviewCtrl"
]
