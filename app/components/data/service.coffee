"use strict"

app = angular.module "app.services"

app.service 'DataService', [
    "$rootScope"
    "MapService"
    "TableService"
    "ConverterService"
    "VisualizationService"
    "$log"
    "DatasetFactory"
    "$translate"
    "$state"
    "ngToast"
    "ProgressService"
    "ErrorHandler"
    ($rootScope, Map, Table, Converter, Visualization, $log, DatasetFactory, $translate, $state, ngToast, Progress, ErrorHandler) ->
        class Data
            constructor: ->
                # Temporarily solution because there is redundance
                # between @name, @metaData and @vidatio
                @datasetID = ""
                @vidatio = {}
                @name = ""
                @metaData =
                    "fileType": "csv"

            updateMap: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                Map.updateGeoJSONWithSHP(row, column, oldData, newData, key)

            validateInput: (row, column, oldData, newData) ->
                columnHeaders = Table.instanceTable.getColHeader()
                key = columnHeaders[column]
                return Map.validateGeoJSONUpdateSHP(row, column, oldData, newData, key)

            # Sends the dataset to the API, which saves it in the database
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
                if data._id?
                    @datasetID = data._id

                if data.metaData?
                    angular.extend @metaData, data.metaData

                if data.visualizationOptions?
                    Visualization.setOptions(data.visualizationOptions)

                if data.metaData.fileType is "shp"
                    Table.setDataset Converter.convertGeoJSON2Arrays data.data
                    Table.useColumnHeadersFromDataset = true
                    Table.setHeader Converter.convertGeoJSON2ColHeaders data.data
                    Table.setColumns()
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

            # @method copyVidatioLink
            # @description copy link for dataset to clipboard and return success-state
            # @param {String} element
            copyVidatioLink: (element) ->
                window.getSelection().removeAllRanges()
                link = document.querySelector element
                range = document.createRange()
                range.selectNode link
                window.getSelection().addRange(range)

                try
                    document.execCommand "copy"
                    $translate("TOAST_MESSAGES.LINK_COPIED")
                    .then (translation) ->
                        ngToast.create
                            content: translation

                catch error
                    $translate("TOAST_MESSAGES.LINK_NOT_COPIED")
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

                window.getSelection().removeAllRanges()

            # @method requestVidatioViaID
            # @description load a vidatio and create the visualization
            # @param {String} id
            requestVidatioViaID: (id) ->
                # get dataset according to datasetId and set necessary metadata
                DatasetFactory.get {id: id}, (data) =>
                    @useSavedData data

                    options = data.visualizationOptions
                    options.fileType = if data.metaData?.fileType? then data.metaData.fileType else "csv"
                    Visualization.create(options)
                    Progress.setMessage()
                , (error) ->
                    Progress.setMessage()
                    ErrorHandler.format error

        new Data
]
