"use strict"

app = angular.module "app.services"

app.service "CatalogService", [
    "$scope"
    "$log"
    "CatalogFactory"
    ($scope, $log, CatalogFactory) ->

        class Catalog

            constructor: ->


            fetchData: ->
                CatalogFactory.query (response) ->
                    console.log(response)
                , (error) ->
                    console.error error

        new Catalog
]
