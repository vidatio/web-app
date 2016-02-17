"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    "DataService"
    "MapService"
    "ConverterService"
    ($scope, Table, Data, Map, Converter) ->
        $scope.dataset = Table.dataset

        $scope.useColumnHeadersFromDataset = Table.useColumnHeadersFromDataset
        $('#column-headers-checkbox').radiocheck()

        # If the imported file is a shp file we always use the column headers
        if Data.meta.fileType is "shp"
            geoJSON = Map.getGeoJSON()
            columnHeaders = Converter.convertGeoJSON2ColHeaders geoJSON
            Table.setColumnHeaders columnHeaders
            $('#header-button').hide()
        else
            $('#header-button').show()

        $scope.$watch ->
            $scope.useColumnHeadersFromDataset
        , ->
            if Data.meta.fileType != "shp"
                if $scope.useColumnHeadersFromDataset
                    Table.takeColumnHeadersFromDataset()
                else
                    Table.putColumnHeadersBackToDataset()
        , true
]
