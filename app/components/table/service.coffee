"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    (Map) ->
        class Table
            constructor: ->
                @dataset = [[]]

            setDataset: (data) ->
                # safely remove all items, keeps data binding alive
                @dataset.splice 0, @dataset.length

                console.log data
                rows = data.split('\n')

                i = 0
                while i < rows.length
                    @dataset.push rows[i].split(',')
                    ++i

                Map.setGeoJSON(@dataset)

            setCell: (row, cell, data) ->
                @dataset[row][cell] = data
                Map.setGeoJSON(@dataset)

            getDataset: ->
                return @dataset

        new Table
]
