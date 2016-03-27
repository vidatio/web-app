"use strict"

app = angular.module "app.factories"

app.factory "TagsFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource($rootScope.apiBase + $rootScope.apiVersion + "/tags/")
]
