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
    "DataFactory"
    "$location"
    "$state"
    (Map, Table, Converter, Visualization, $rootScope, ngToast, $translate, $log, DataFactory, $location, $state) ->
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
            saveViaAPI: (dataset, name = "Neues Vidatio") ->
                $log.info("saveViaAPI called")
                $log.debug
                    dataset: dataset
                    name: name

                DataFactory.save
                    name: name
                    data: dataset
                    metaData:
                        fileType: @meta.fileType
                        fileName: @meta.fileName
                    options:
                        diagramType: Visualization.options.diagramType
                        xAxisCurrent: Visualization.options.xAxisCurrent
                        yAxisCurrent: Visualization.options.yAxisCurrent
                        color: Visualization.options.color
                        selectedDiagramName: Visualization.options.selectedDiagramName
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


            createVidatio: (data) ->
                $log.info "DatasetCtrl createVidatio called"

                if @meta["fileType"] is "shp"
                    dataset = Converter.convertGeoJSON2Arrays data.data
                    Table.setDataset dataset
                    Table.useColumnHeadersFromDataset = true
                    Map.setGeoJSON data.data
                else
                    if data.options?
                        # Each value has to be assigned individually, otherwise all options get overwritten.
                        Visualization.options["diagramType"] = data.options.diagramType || false
                        Visualization.options["xAxisCurrent"] = data.options.xAxisCurrent || 0
                        Visualization.options["yAxisCurrent"] = data.options.yAxisCurrent || 0
                        Visualization.options["color"] = data.options.color || "#11DDC6"
                        Visualization.options["selectedDiagramName"] = data.options.selectedDiagramName || null

                        if data.options.useColumnHeadersFromDataset?
                            Table.useColumnHeadersFromDataset = data.options.useColumnHeadersFromDataset || false

                            if Table.useColumnHeadersFromDataset
                                Table.setHeader data.data.shift()

                    Table.setDataset data.data

        new Data
]
