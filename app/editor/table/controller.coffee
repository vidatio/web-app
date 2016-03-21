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
    "VisualizationService"
    ($scope, Table, Share, Data, Map, Converter, $log, Visualization) ->
        $scope.dataset = Table.dataset
        $scope.data = Data
        $scope.visualization = Visualization.options

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

            trimmedDataset = vidatio.helper.trimDataset Table.getDataset()

            if Table.useColumnHeadersFromDataset
                csv = Papa.unparse
                    fields: Table.getHeader(),
                    data: trimmedDataset
            else
                csv = Papa.unparse trimmedDataset

            if $scope.data.name is ""
                fileName = "vidatio_#{vidatio.helper.dateToString(new Date())}"
            else
                fileName = $scope.data.name

            csvData = new Blob([csv], {type: "text/csv;charset=utf-8;"})
            csvURL = window.URL.createObjectURL(csvData)

            Share.download fileName + ".csv", csvURL

        $scope.axisSelection = (axis) ->
            $header = $(".ht_clone_top th")
            $header.removeClass "selected"
            $header.unbind "click"

            if axis is "x"
                if $(".x-axis-button").hasClass "selected"
                    $(".x-axis-button").removeClass "selected"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.xColumn) + 1
                $(".y-axis-button").removeClass "selected"
                $(".x-axis-button").addClass "selected"
            else
                if $(".y-axis-button").hasClass "selected"
                    $(".y-axis-button").removeClass "selected"
                    $header.removeClass "highlighted"
                    return true
                currentColumn = Number($scope.visualization.yColumn) + 1
                $(".x-axis-button").removeClass "selected"
                $(".y-axis-button").addClass "selected"

            $header.addClass "highlighted"

            $header.each (idx, element) ->
                if idx is currentColumn
                    $(element).addClass "selected"

                $(element).click (event) ->
                    if axis is "x"
                        $scope.visualization.xColumn = $(element).context.cellIndex - 1
                    else
                        $scope.visualization.yColumn = $(element).context.cellIndex - 1

                    Visualization.create()

                    $("[class*='-axis-button']").removeClass "selected"
                    $header.removeClass "highlighted"
                    $header.removeClass "selected"
                    $header.unbind "click"

            return true
]
