"use strict"

app = angular.module "app.directives"

app.directive "login", [ ->
    restrict: "E"
    templateUrl: "components/login/directive.html"
    replace: true
    controller: "LoginCtrl"
]
