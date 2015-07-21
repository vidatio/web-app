"use strict"

app = angular.module "app.services"

app.service 'TableService', [
    "MapService"
    (Map) ->
        class Table
            constructor: ->
                @dataset = [[]]

            setDataset: (data) ->
                console.log "set dataset - tableservice"
                # safely remove all items, keeps data binding alive
                @dataset.splice 0, @dataset.length

                rows = data.split('\n')

                i = 0
                while i < rows.length
                    @dataset.push rows[i].split(',')
                    ++i

                Map.setMarkers(@dataset)

            setCell: (row, cell, data) ->
                console.log "set cell"
                @dataset[row][cell] = data
                Map.setMarkers(@dataset)

            getDataset: ->
                return @dataset

        new Table
]
