"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    (Map) ->
        class Table
            constructor: ->
                @dataset = [[]]

            reset: ->
                # safely remove all items, keeps data binding alive
                # there should be left a 2D array - needed for handsontable
                @dataset.splice 0, @dataset.length - 1
                @dataset[0].splice 0, @dataset[0].length

            setDataset: (data) ->
                @reset()
                data.forEach (row, index) ->
                    console.log @dataset
                    @dataset[index] = row
                Map.setGeoJSON(@dataset)

            setCell: (row, cell, data) ->
                @dataset[row][cell] = data
                Map.setGeoJSON(@dataset)

            getDataset: ->
                return @dataset

        new Table
]
