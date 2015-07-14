"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    ($scope, Table) ->
        $scope.rows = Table.dataset
        $scope.settings =
            colHeaders: true
            rowHeaders: true
            minCols: 26
            minRows: 26
            currentRowClassName: 'current-row'
            currentColClassName: 'current-col'
]
