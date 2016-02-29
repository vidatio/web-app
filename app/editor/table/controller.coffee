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

        $scope.showDownloadButton = Data.meta.fileName is "csv"

        #@method $scope.download
        #@description downloads a csv
        $scope.download = ->
            $log.info "TableCtrl download called"

            trimmedDataset = vidatio.helper.trimDataset Table.getDataset()

            if Table.useColumnHeadersFromDataset
                csv = Papa.unparse
                    fields: Table.getColumnHeaders(),
                    data: trimmedDataset
            else
                csv = Papa.unparse trimmedDataset

            if Data.meta.fileName is ""
                fileName = "vidatio_#{vidatio.helper.dateToString(new Date())}"
            else
                fileName = Data.meta.fileName

            csvData = new Blob([csv], {type: "text/csv;charset=utf-8;"})
            csvURL = window.URL.createObjectURL(csvData)

            Share.download fileName + ".csv", csvURL
]
