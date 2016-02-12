"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    ($scope, CatalogFactory) ->
        $scope.dates =
            from: undefined
            to: undefined
            maxDate: moment.tz('UTC').hour(12).startOf('h')

        $scope.maxDate = $scope.dates.maxDate

        CatalogFactory.query (response) ->
            $scope.vidatios = response

            for vidatio in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)
        , (error) ->
            console.error error

]
