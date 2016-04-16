"use strict"

app = angular.module "app.directives"

app.directive "registration", [ ->
    restrict: "E"
    templateUrl: "components/registration/registration.html"
    replace: true
    controller: "LoginCtrl"
]
