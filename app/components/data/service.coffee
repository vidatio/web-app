"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    (Map, Table) ->
        class Data
            constructor: ->
                @geoJSON

            setGeoJSON: (geoJSON) ->
                @geoJSON = geoJSON

            updateTableAndMap: (row, column, data) ->
                Table.setCell(row, column, data)

                # update geojson


                Map.setGeoJSON(@geoJSON)

            updateGeoJSON: (row, column, data) ->
                @geoJSON.features[row]


        new Data
]
