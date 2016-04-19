"use strict"
app = angular.module "app.directives"

app.directive "vidatioProgress", [ ->
    restrict: "E"
    templateUrl: "components/progress/progress.html"
    controller: "ProgressCtrl"
    scope:
        progressMessage: "="
    replace: true
    link: (scope, element) ->
        console.log("Progress Message: ", scope.progressMessage)

        scope.$watch ->
            scope.progressMessage
        , (newValue, oldValue) ->
            console.log("Progress message changed! (", oldValue, " -> ", newValue, ")")
]
