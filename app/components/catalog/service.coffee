"use strict"

app = angular.module "app.services"

app.service 'CatalogService', [
    "$log"
    "$q"
    "CatalogFactory"
    ($log, $q, CatalogFactory) ->

        class Catalog

            fetchData: ->
                deferred = $q.defer()

                CatalogFactory.query (response) ->
                    deferred.resolve(response)
                , (error) ->
                    console.error error
                    deferred.reject(error)

                return deferred.promise

        new Catalog
]
