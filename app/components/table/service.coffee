"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "$log"
    "MapService"
    "ConverterService"
    ($log, Map, Converter) ->
        class Table
            constructor: ->
                $log.info "TableService constructor called"

                @dataset = [[]]
                @colHeaders = []

                @xAxis = []
                @yAxis = []
                @instanceTable = {}

            initAxisSelection: ->
                $log.info "TableService initAxis called"

                hot = @getInstance()
                colHeaders = hot.getColHeader()

                $log.debug
                    colHeaders: colHeaders

                @setXAxis colHeaders
                @setYAxis colHeaders

            setXAxis: (colHeaders) ->
                $log.info "TableService setXAxis called"

                @xAxis.splice 0, @xAxis.length
                colHeaders.forEach (item, index) =>
                    @xAxis[index] = item

            setYAxis: (colHeaders) ->
                $log.info "TableService setYAxis called"

                @yAxis.splice 0, @yAxis.length
                colHeaders.forEach (item, index) =>
                    @yAxis[index] = item

            setInstance: (hot) ->
                $log.info "TableService setInstance called"

                @instanceTable = hot

            getInstance: ->
                $log.info "TableService getInstance called"

                return @instanceTable

            resetColHeaders: ->
                $log.info "TableService resetColHeaders called"

                @colHeaders.splice 0, @colHeaders.length

            setColHeaders: (colHeaders) ->
                $log.info "TableService setColHeaders called"
                $log.debug
                    message: "TableService setColHeaders called"
                    colHeaders: colHeaders

                @resetColHeaders()
                colHeaders.forEach (item, index) =>
                    @colHeaders[index] = item

            resetDataset: ->
                $log.info "TableService resetDataset called"

                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            setDataset: (data) ->
                $log.info "TableService setDataset called"
                $log.debug
                    message: "TableService setDataset called"
                    data: data

                @resetDataset()
                data.forEach (row, index) =>
                    @dataset[index] = row

            setCell: (row, column, data) ->
                $log.info "TableService setCell called"
                $log.debug
                    message: "TableService setCell called"
                    row: row
                    column: column
                    data: data

                @dataset[row][column] = data

            getDataset: ->
                $log.info "TableService getDataset called"

                return @dataset

        new Table
]
