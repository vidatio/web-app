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
    "$location"
    "$state"
    (Map, Table, Converter, $rootScope, ngToast, $translate, $log, DataFactory, $location, $state) ->
        class Data
            constructor: ->
                $log.info "DataService constructor called"

                @meta =
                    "fileType": ""
                    "fileName": ""

            updateTableAndMap: (row, column, oldData, newData) ->
                $log.info "DataService updateTableAndMap called"
                $log.debug
                    message: "DataService updateTableAndMap called"
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

            # TODO: Name has to be set by the user

            # Sends the dataset to the API, which saves it in the database.
            # @method saveViaAPI
            # @param {Object} dataset
            # @param {String} userId
            # @param {String} name
            saveViaAPI: (dataset, name = "Neues Vidatio") ->
                $log.info("saveViaAPI called")
                $log.debug
                    dataset: dataset
                    name: name

                DataFactory.save
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

                    link = $state.href("app.dataset", {id: response._id}, {absolute: true})
                    $rootScope.link = link
                    $rootScope.showLink = true
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
