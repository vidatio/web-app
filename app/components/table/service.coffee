"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    (Map) ->
        class Table
            constructor: ->
                @dataset = [[]]

            reset: ->
                @setDataset("")

            setDataset: (data) ->
                console.log(data, @dataset)
                # safely remove all items, keeps data binding alive
                @dataset.splice 0, @dataset.length

                console.log(data, @dataset)
                rows = data.split('\n')

                i = 0
                while i < rows.length
                    @dataset.push rows[i].split(',')
                    ++i

                Map.setGeoJSON(@dataset)

            setDatasetFromGeojson: (geojson) ->
                # safely remove all items, keeps data binding alive
                @dataset.splice 0, @dataset.length

                geojson.features.forEach (feature) =>
                    newRow = []
                    newRow.push feature.geometry.type

                    feature.geometry.coordinates.forEach (coordinate) ->
                        newRow.push coordinate

                    for property,value of feature.properties
                        newRow.push value

                    @dataset.push newRow

                console.log "@dataset", @dataset


            setCell: (row, cell, data) ->
                @dataset[row][cell] = data
                Map.setGeoJSON(@dataset)

            getDataset: ->
                return @dataset

        new Table
]
