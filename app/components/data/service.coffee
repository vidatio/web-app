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

                console.log Table.dataset

                if @meta.fileType == "shp"
                    return Map.updateGeoJSONwithSHP(row, column, oldData, newData, key)

                else if @meta.fileType == "csv"
                    geoJSON = Converter.convertArrays2GeoJSON(Table.dataset)
                    Map.setGeoJSON(geoJSON)

                return false

        new Data
]
