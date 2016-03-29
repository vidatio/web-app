"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "MapService"
    "TableService"
    "ConverterService"
    "VisualizationService"
    "$rootScope"
    "ngToast"
    "$translate"
    "$log"
    "DatasetFactory"
    "$location"
    "$state"
    "ShareService"
    (Map, Table, Converter, Visualization, $rootScope, ngToast, $translate, $log, DatasetFactory, $location, $state, Share) ->
        class Data
            constructor: ->
                $log.info "DataService constructor called"

                @name = ""
                @metaData =
                    "fileType": ""

            updateMap: (row, column, oldData, newData) ->
                $log.info "DataService updateMap called"
                $log.debug
                    message: "DataService updateMap called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData

                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                Map.updateGeoJSONWithSHP(row, column, oldData, newData, key)

            validateInput: (row, column, oldData, newData) ->
                $log.info "DataService validateInput called"
                $log.debug
                    message: "DataService validateInput called"
                    row: row
                    column: column
                    oldData: oldData
                    newData: newData

                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

            # TODO: Name has to be set by the user

            # Sends the dataset to the API, which saves it in the database.
            # @method saveViaAPI
            # @param {Object} dataset
            # @param {String} name
            saveViaAPI: (dataset, metaData) ->
                $log.info("saveViaAPI called")
                $log.debug
                    dataset: dataset
                    metaData: metaData

                angular.extend @metaData, metaData

                DatasetFactory.save
                    name: @name
                    data: dataset
                    published: @metaData.publish
                    metaData: @metaData
                    options:
                        type: Visualization.options.type
                        xColumn: Visualization.options.xColumn
                        yColumn: Visualization.options.yColumn
                        color: Visualization.options.color
                        useColumnHeadersFromDataset: Table.useColumnHeadersFromDataset
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
                    $log.error("Dataset couldn't be saved")
                    $log.debug
                        error: error

                    $translate('TOAST_MESSAGES.DATASET_NOT_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

            # @method useSavedData
            # @description from existing dataset
            # @param {Object} data
            useSavedData: (data) ->
                $log.info "DataService useSavedData called"
                $log.debug
                    data: data


                @meta.fileType = if data.metaData?.fileType? then data.metaData.fileType else null
                Visualization.options.fileType = @meta.fileType
                Table.useColumnHeadersFromDataset = if data.options?.useColumnHeadersFromDataset? then data.options.useColumnHeadersFromDataset else false

                if @meta.fileType is "shp"
                    Table.setDataset Converter.convertGeoJSON2Arrays data.data
                    Table.setHeader Converter.convertGeoJSON2ColHeaders data.data
                    Map.setGeoJSON data.data
                else
                    if Table.useColumnHeadersFromDataset
                        Table.setHeader data.data.shift()
                    Table.setDataset data.data

                if data.options?
                    Visualization.setOptions(data.options)

            #@method downloadCSV
            #@description downloads a csv
            downloadCSV: (name) ->
                $log.info "TableCtrl download called"

                trimmedDataset = vidatio.helper.trimDataset Table.getDataset()

                if Table.useColumnHeadersFromDataset
                    csv = Papa.unparse
                        fields: Table.getHeader(),
                        data: trimmedDataset
                else
                    csv = Papa.unparse trimmedDataset

                if name is ""
                    fileName = "vidatio_#{vidatio.helper.dateToString(new Date())}"
                else
                    fileName = name

                csvData = new Blob([csv], {type: "text/csv;charset=utf-8;"})
                csvURL = window.URL.createObjectURL(csvData)

                Share.download fileName + ".csv", csvURL

        new Data
]
