"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    "ConverterService"
    "$http"
    "$rootScope"
    "ngToast"
    "$translate"
    "$log"
    (Map, Table, Converter, $http, $rootScope, ngToast, $translate, $log) ->
        class Data
            constructor: ->
                @meta =
                    "fileType": ""
                    "fileName": ""

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

            # UserId and Name have to be set by the user
            saveViaAPI: (dataset, userId = "123456781234567812345678", name = "Neues Vidatio") ->
                $log.info("saveViaAPI called")
                $log.debug
                    dataset: dataset
                    userId: userId
                    name: name

                request =
                    method: 'POST'
                    url: $rootScope.apiBase + "/v0/dataset"
                    data:
                        userId: userId
                        name: name
                        data: dataset

                $http(request).then (result) ->
                    $log.info("Dataset successfully saved")
                    $log.debug
                        _id: result.data._id
                        name: result.data.name
                        userId: result.data.userId
                        createdAt: result.data.createdAt

                    $translate('TOAST_MESSAGES.DATASET_SAVED')
                        .then (translation) ->
                            ngToast.create
                                content: translation

        new Data
]
