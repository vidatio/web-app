"use strict"

app = angular.module "app.directives"

app.directive "login", [ ->
    restrict: "E"
    templateUrl: "login/login.html"
    replace: true
]
