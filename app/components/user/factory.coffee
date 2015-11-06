"use strict"

app = angular.module "app.factories"

app.factory 'UserFactory', [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + "/user/:id"
]
