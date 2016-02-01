"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    "ConverterService"
    "$rootScope"
    "ngToast"
    "$translate"
    "$log"
    "DataFactory"
    (Map, Table, Converter, $rootScope, ngToast, $translate, $log, DataFactory) ->
        class Data
            constructor: ->
                $log.info "DataService constructor called"

                @meta =
                    "fileType": ""
                    "fileName": ""

            updateMap: (row, column, oldData, newData) ->
                $log.info "DataService updateMap called"
                $log.debug
                    message: "DataService updateMap called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData

                key = Table.colHeaders[column]

                if @meta.fileType is "shp"
                    Map.updateGeoJSONWithSHP(row, column, oldData, newData, key)
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

            # TODO: UserId and Name have to be set by the user
            # Sends the dataset to the API, which saves it in the database.
            # @method saveViaAPI
            # @param {Object} dataset
            # @param {String} userId
            # @param {String} name
            saveViaAPI: (dataset, userId = "123456781234567812345678", name = "Neues Vidatio") ->
                $log.info("saveViaAPI called")
                $log.debug
                    dataset: dataset
                    userId: userId
                    name: name

                DataFactory.save
                    userId: userId
                    name: name
                    data: dataset
                , (response) ->
                    $log.info("Dataset successfully saved")
                    $log.debug
                        response: response

                    $translate('TOAST_MESSAGES.DATASET_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                , (error) ->
                    $log.info("Dataset couldn't be saved")
                    $log.error
                        error: error

                    $translate('TOAST_MESSAGES.DATASET_NOT_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
        new Data
]
