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

            resetColHeaders: ->
                @colHeaders.splice 0, @colHeaders.length

            setColHeaders: (colHeaders) ->
                @resetColHeaders()
                colHeaders.forEach (item, index) =>
                    @colHeaders[index] = item

            reset: ->
                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            setDataset: (data) ->
                @reset()
                data.forEach (row, index) =>
                    @dataset[index] = row

            setCell: (row, column, data) ->
                @dataset[row][column] = data

            getDataset: ->
                return @dataset

        new Table
]
