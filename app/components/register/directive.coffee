"use strict"

app = angular.module "app.directives"

app.directive "register", [ ->
    restrict: "E"
    templateUrl: "components/register/directive.html"
    replace: true
    controller: "LoginCtrl"
]
