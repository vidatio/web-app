"use strict"

app = angular.module "app.directives"

app.factory "UserFactory", [
    "$resource"
    ($resource) ->
        $resource $rootScope.apiBase + "/v0/users/:users", {user: "@user"}
]
