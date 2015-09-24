"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    "ConverterService"
    (Map, Table, Converter) ->
        class Data
            constructor: ->
                @meta =
                    "fileType": ""

            updateTableAndMap: (row, column, oldData, newData) ->
                key = Table.colHeaders[column]

                if @meta.fileType == "shp"
                    return Map.updateGeoJSONwithSHP(row, column, oldData, newData, key)

                else if @meta.fileType == "csv"
                    geoJSON = Converter.convertArrays2GeoJSON(Table.dataset)
                    Map.setGeoJSON(geoJSON)

                else
                    geoJSON = Converter.convertArrays2GeoJSON(Table.dataset)
                    Map.setGeoJSON(geoJSON)

                return true
        new Data
]
