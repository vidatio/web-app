"use strict"

app = angular.module "app.controllers"

app.controller "TableCtrl", [
    "$scope"
    "TableService"
    "ShareService"
    "DataService"
    "MapService"
    "ConverterService"
    "$log"
    ($scope, Table, Share, Data, Map, Converter, $log) ->
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

        $scope.changeUseOfHeader = ->
            $log.info "TableCtrl changeUseOfHeader called"

            if Data.meta.fileType != "shp"
                if $scope.useColumnHeadersFromDataset
                    Table.takeColumnHeadersFromDataset()
                else
                    Table.putColumnHeadersBackToDataset()

        #@method $scope.download
        #@description exports a
        #@params {string} type
        $scope.download = (type) ->
            $log.info "TableCtrl download called"
            $log.debug
                type: type

            dataset = vidatio.helper.trimDataset Table.getDataset()

            if Table.useColumnHeadersFromDataset
                csv = Papa.unparse
                    fields: Table.getColumnHeaders(),
                    data: dataset
            else
                csv = Papa.unparse dataset

            if Data.meta.fileName == ""
                fileName = vidatio.helper.dateToString(new Date())
            else
                fileName = Data.meta.fileName

            csvData = new Blob([csv], {type: 'text/csv;charset=utf-8;'})
            csvURL = window.URL.createObjectURL(csvData)

            Share.download fileName + "." + type, csvURL
]
