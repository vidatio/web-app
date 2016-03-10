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
        $scope.meta = Data.meta

        # attention: one way data binding
        $scope.useColumnHeadersFromDataset = Table.useColumnHeadersFromDataset

        headerCheckbox = $('#column-headers-checkbox')
        if headerCheckbox? and headerCheckbox.radiocheck? then headerCheckbox.radiocheck()

        $scope.toggleHeader = ->
            $log.info "TableCtrl changeUseOfHeader called"

            if Data.meta.fileType isnt "shp"
                if $scope.useColumnHeadersFromDataset
                    Table.takeHeaderFromDataset()
                else
                    Table.putHeaderToDataset()

        #@method $scope.transpose
        #@description transpose the dataset including the header
        $scope.transpose = ->
            $log.info "TableCtrl transpose called"

            if $scope.useColumnHeadersFromDataset then Table.putHeaderToDataset()
            Table.setDataset vidatio.helper.transposeDataset Table.getDataset()
            if $scope.useColumnHeadersFromDataset then Table.takeHeaderFromDataset()

        #@method $scope.download
        #@description downloads a csv
        $scope.download = ->
            $log.info "TableCtrl download called"

            trimmedDataset = vidatio.helper.trimDataset Table.getDataset()

            if Table.useColumnHeadersFromDataset
                csv = Papa.unparse
                    fields: Table.getHeader(),
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
