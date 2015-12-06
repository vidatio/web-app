"use strict"

app = angular.module "app.factories"

app.factory "DataFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/datasets/:id"
]
