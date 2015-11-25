"use strict"

app = angular.module "app.factories"

app.factory "CatalogFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + "/v0/datasets/"

]
