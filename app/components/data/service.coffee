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
                # This function updates the geoJSON after table changes
                key = Table.colHeaders[column]
                keys = key.split(" ")

                if keys[0] == "coordinates"
                    if Map.geoJSON.features[row].geometry.type == "Point"
                        Map.geoJSON.features[row].geometry.coordinates[keys[1]] = newData

                else if keys[0] == "bbox"
                    Map.geoJSON.features[row].geometry.bbox[keys[1]] = newData

                # check if colHeader is part of properties
                else
                    for property, value of Map.geoJSON.features[row].properties
                        if key == property
                            Map.geoJSON.features[row].properties[key] = newData

        new Data
]
