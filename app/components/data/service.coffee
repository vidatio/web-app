"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "$rootScope",
    "MapService"
    "TableService"
    "ConverterService"
    "VisualizationService"
    "$log"
    "DatasetFactory"
    "$translate"
    "$state"
    "ngToast"
    ($rootScope, Map, Table, Converter, Visualization, $log, DatasetFactory, $translate, $state, ngToast) ->
        class Data
            constructor: ->
                @name = ""
                @metaData =
                    "fileType": ""

            updateMap: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                Map.updateGeoJSONWithSHP(row, column, oldData, newData, key)

            validateInput: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

            # TODO: Name has to be set by the user

            # Sends the dataset to the API, which saves it in the database.
            # @method saveViaAPI
            # @param {Object} dataset
            # @param {String} name
            saveViaAPI: (dataset, metaData, thumbnail = "-", cb) ->
                angular.extend @metaData, metaData

                DatasetFactory.save
                    data: dataset
                    published: @metaData.publish
                    metaData: @metaData
                    visualizationOptions:
                        type: Visualization.options.type
                        xColumn: Visualization.options.xColumn
                        yColumn: Visualization.options.yColumn
                        color: Visualization.options.color
                        useColumnHeadersFromDataset: Table.useColumnHeadersFromDataset
                        thumbnail: thumbnail
                , (response) ->
                    link = $state.href("app.dataset", {id: response._id}, {absolute: true})
                    $rootScope.link = link
                    $rootScope.showLink = true

                    return cb null, response

                , (error) ->
                    $log.error("Dataset couldn't be saved")
                    $log.debug
                        error: error

                    return cb error, null

            # @method useSavedData
            # @description from existing dataset
            # @param {Object} data
            useSavedData: (data) ->
                if data.metaData?
                    @metaData = data.metaData

                if data.visualizationOptions?
                    Visualization.setOptions(data.visualizationOptions)

                if data.metaData.fileType is "shp"
                    Table.setDataset Converter.convertGeoJSON2Arrays data.data
                    Table.useColumnHeadersFromDataset = true
                    Table.setHeader Converter.convertGeoJSON2ColHeaders data.data
                    Map.setGeoJSON data.data
                else
                    Table.useColumnHeadersFromDataset = false
                    if data.visualizationOptions.useColumnHeadersFromDataset
                        Table.useColumnHeadersFromDataset = true

                    if Table.useColumnHeadersFromDataset
                        Table.setHeader data.data.shift()

                    Table.setDataset data.data

            #@method downloadCSV
            #@description downloads a csv
            downloadCSV: (name) ->
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

                vidatio.visualization.download fileName + ".csv", csvURL

        new Data
]
