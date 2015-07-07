# Table Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    ($scope, Table) ->
        $scope.rows = Table.dataset

        Table.setDataset 'Montag,5\nDienstag,2\nMittwoch,4'

        $scope.colHeaders = true
        $scope.rowHeaders = true
        $scope.minCols = 26
        $scope.minRows = 26
        $scope.autoColumnSize = true
        $scope.currentColClassName = 'current-col'
]
