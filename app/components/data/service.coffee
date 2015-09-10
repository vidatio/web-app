"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    (Map, Table) ->
        class Data
            updateTableAndMap: (row, column, oldData, newData) ->
                Table.setCell(row, column, newData)

                this.updateGeoJSON(row, column, oldData, newData)

            updateGeoJSON: (row, column, oldData, newData) ->
                # This funtion should update the geoJSON after table changes
                # console.log "row", row
                # console.log "column", column
                # console.log "oldData", oldData
                # console.log "newData", newData

                key = Table.colHeaders[column]

                geoJSON = Map.geoJSON

                # check if colHeader is part of properties
                for property, value of geoJSON.features[row].properties
                    if key == property
                        geoJSON.features[row].properties[key] = newData

                Map.setGeoJSON(geoJSON)

        new Data
]
