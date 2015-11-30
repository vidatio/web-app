"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogService"
    ($scope, Catalog) ->

        Catalog.fetchData().then (data) ->
            $scope.data = data
            console.log $scope.data
]
