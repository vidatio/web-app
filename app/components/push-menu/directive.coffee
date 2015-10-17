"use strict"
app = angular.module "app.directives"

app.directive "pushMenu", [
    ->
        return {
        restrict: "EA"
        templateUrl: "push-menu/push-menu.html"
        controller: "PushMenuController"
        replace: true
        }
]
