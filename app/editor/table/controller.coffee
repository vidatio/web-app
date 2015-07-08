"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    ($scope, Table) ->
        $scope.rows = Table.dataset

        Table.setDataset '47.723955,13.084850\n47.725081,13.087736\n47.724881,13.086685'

        $scope.colHeaders = true
        $scope.rowHeaders = true
        $scope.minCols = 26
        $scope.minRows = 26
        $scope.autoColumnSize = true
        $scope.currentColClassName = 'current-col'
]
