"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    "ConverterService"
    (Map, Converter) ->
        class Table
            constructor: ->
                @dataset = [[]]
                @colHeaders = []

            setColHeaders: (colHeaders) ->
                # console.log "1:", @colHeaders
                # @colHeaders.splice 0, @colHeaders.length - 1
                # console.log "2:", @colHeaders
                # @colHeaders = ["test", "test2", "3"]
                console.log "3:", @colHeaders
                @colHeaders = colHeaders
                console.log "4:", @colHeaders

            reset: ->
                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            setDataset: (data) ->
                console.log "1:", @dataset
                @reset()
                console.log "2:", @dataset
                data.forEach (row, index) =>
                    @dataset[index] = row
                console.log "3:", @dataset

            setCell: (row, column, data) ->
                @dataset[row][column] = data

            getDataset: ->
                return @dataset

        new Table
]
