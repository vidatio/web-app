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
