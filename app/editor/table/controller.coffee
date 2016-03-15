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
        $scope.data = Data

        # attention: one way data binding
        $scope.useColumnHeadersFromDataset = Table.useColumnHeadersFromDataset

        headerCheckbox = $('#column-headers-checkbox')
        if headerCheckbox?.radiocheck? then headerCheckbox.radiocheck()

        $scope.toggleHeader = ->
            $log.info "TableCtrl changeUseOfHeader called"

            if $scope.data.meta.fileType isnt "shp"
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
            Data.downloadCSV($scope.data.name)
]
