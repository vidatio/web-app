"use strict"

app = angular.module "app.directives"

app.directive "vidatioOverview", [ ->
    restrict: "E"
    templateUrl: "components/vidatio/vidatio.html"
    replace: false
    scope:
        vidatio: "="
    controller: "VidatioOverviewCtrl"
]
