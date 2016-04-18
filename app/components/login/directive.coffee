"use strict"

app = angular.module "app.directives"

app.directive "login", [ ->
    restrict: "E"
    templateUrl: "components/login/login.html"
    replace: true
    controller: "LoginCtrl"
]
