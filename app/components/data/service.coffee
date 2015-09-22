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

            updateTableAndMap: (row, column, oldData, newData) ->
                Table.setCell(row, column, newData)

                this.updateGeoJSON(row, column, oldData, newData)

                Map.setGeoJSON(@geoJSON)

            updateGeoJSON: (row, column, oldData, newData) ->
                # This funtion should update the geoJSON after table changes
                # console.log "update"
                # console.log @geoJSON.features[row]

        new Data
]
