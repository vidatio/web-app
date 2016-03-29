"use strict"

app = angular.module "app.factories"

app.factory "CategoriesFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource($rootScope.apiBase + $rootScope.apiVersion + "/categories/")
]
