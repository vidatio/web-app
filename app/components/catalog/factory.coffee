"use strict"

app = angular.module "app.factories"

app.factory "CatalogFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->

        class CatalogFactory

            getDatasets: ->
                return $resource($rootScope.apiBase + $rootScope.apiVersion + "/datasets/")

            getCategories: ->
                return $resource($rootScope.apiBase + $rootScope.apiVersion + "/categories/")

        new CatalogFactory
]
