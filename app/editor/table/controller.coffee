"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    ($scope, Table) ->
        $scope.dataset = Table.dataset
        $scope.colHeaders = Table.colHeaders
]
