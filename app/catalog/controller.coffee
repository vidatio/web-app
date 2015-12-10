"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    ($scope, CatalogFactory) ->
        CatalogFactory.query (response) ->
            $scope.vidatios = response

            for vidatio in $scope.vidatios
                console.log(vidatio)
                vidatio.description = "Hello world, this is a test!"
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
        , (error) ->
            console.error error
]
