"use strict"
app = angular.module "app.directives"

app.directive "vidatioProgress", [ ->
    restrict: "E"
    templateUrl: "components/progress/progress.html"
    controller: "ProgressCtrl"
    replace: true
]
