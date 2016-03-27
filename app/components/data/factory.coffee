"use strict"

app = angular.module "app.factories"

app.factory "DatasetFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource $rootScope.apiBase + $rootScope.apiVersion + "/datasets/:id"
]

app.factory "DatasetsFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->
        $resource($rootScope.apiBase + $rootScope.apiVersion + "/datasets/")
]
