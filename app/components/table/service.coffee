"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    "ConverterService"
    (Map, Converter) ->
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
                data.forEach (row, index) =>
                    @dataset[index] = row

                geoJSON = Converter.convertArrays2GeoJSON(@dataset)
                Map.setGeoJSON(geoJSON)

            setCell: (row, cell, data) ->
                @dataset[row][cell] = data

                geoJSON = Converter.convertArrays2GeoJSON(@dataset)
                Map.setGeoJSON(geoJSON)

            getDataset: ->
                return @dataset

        new Table
]
