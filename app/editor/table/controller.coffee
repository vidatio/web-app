"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    "DataService"
    ($scope, Table, Data) ->
        $scope.dataset = Table.dataset
        $scope.columnHeaders = Table.columnHeaders

        $scope.columnHeadersFlag = true
        $('#column-headers-checkbox').radiocheck()

        # When SHP is imported we always use the column headers
        if Data.meta.fileType is "shp"
            $('#column-headers-checkbox').radiocheck('disable')
        else
            $('#column-headers-checkbox').radiocheck('enable')

        $scope.$watch ->
            $scope.columnHeadersFlag
        , ->
            if $scope.columnHeadersFlag
                Table.takeColumnHeadersFromDataset()
            else
                Table.putColumnHeadersBackToDataset()
        , true
]
