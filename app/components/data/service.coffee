"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "$log"
    "MapService"
    "TableService"
    "ConverterService"
    ($log, Map, Table, Converter) ->
        class Data
            constructor: ->
                $log.info "DataService constructor called"

                @meta =
                    "fileType": ""
                    "fileName": ""

            updateTableAndMap: (row, column, oldData, newData) ->
                $log.info "DataService updateTableAndMap called"
                $log.debug
                    message: "DataService validateInput called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData

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
                $log.info "DataService validateInput called"
                $log.debug
                    message: "DataService validateInput called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData

                if @meta.fileType is "shp"
                    key = Table.colHeaders[column]
                    return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

                return true

        new Data
]
