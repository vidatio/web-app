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

                if @meta.fileType is "shp"
                    Map.updateGeoJSONwithSHP(row, column, oldData, newData, key)
                else if @meta.fileType is "csv"
                    geoJSON = Converter.convertArrays2GeoJSON(Table.dataset)
                    Map.setGeoJSON(geoJSON)
                # last else to update empty table
                else
                    geoJSON = Converter.convertArrays2GeoJSON(Table.dataset)
                    Map.setGeoJSON(geoJSON)

            validateInput: (row, column, oldData, newData) ->

                if @meta.fileType is "shp"
                    key = Table.colHeaders[column]
                    return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

                return true

        new Data
]
