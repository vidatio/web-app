"use strict"
app = angular.module "app.directives"

app.directive "vidatioProgress", [ ->
    restrict: "E"
    templateUrl: "components/progress/progress.html"
    scope:
        progressMessage: "="
    replace: true
]
