"use strict"

app = angular.module "app.factories"

app.factory "CatalogFactory", [
    "$resource"
    "$rootScope"
    ($resource, $rootScope) ->

        class CatalogFactory

            getDatasets: ->
                return $resource($rootScope.apiBase + "/v0/datasets/")

            getCategories: ->
                return $resource($rootScope.apiBase + "/v0/categories/")

        new CatalogFactory
]
