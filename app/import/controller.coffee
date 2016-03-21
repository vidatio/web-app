# Import Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ImportCtrl", [
    "$scope"
    "$http"
    "$location"
    "$log"
    "$rootScope"
    "$timeout"
    "$translate"
    "ImportService"
    "TableService"
    "ConverterService"
    "MapService"
    "DataService"
    "ngToast"
    "ProgressService"
    "VisualizationService"
    ($scope, $http, $location, $log, $rootScope, $timeout, $translate, Import, Table, Converter, Map, Data, ngToast, Progress, Visualization) ->
        $scope.link = "http://data.ooe.gv.at/files/cms/Mediendateien/OGD/ogd_abtStat/Wahl_LT_09_OGD.csv"

        $scope.importService = Import

        editorPath = "/" + $rootScope.locale + "/editor"

        $scope.continueToEmptyTable = ->
            $log.info "ImportCtrl continueToEmptyTable called"

            Data.metaData.fileType = "csv"
            Table.useColumnHeadersFromDataset = false
            Visualization.resetOptions()
            Table.setDataset()
            Map.resetGeoJSON()

            # REFACTOR Need to wait for leaflet directive to reset its geoJSON
            $timeout ->
                $location.path editorPath

        # Read via link
        $scope.load = ->
            $log.info "ImportCtrl load called"

            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message

                url = $scope.link
                $http.get($rootScope.apiBase + "/v0/forward"
                    params:
                        url: url
                ).success (resp) ->
                    $log.info "ImportCtrl load success called"
                    $log.debug
                        data: resp.body

                    fileContent = if resp.fileType is 'zip' then resp.body.data else resp.body
                    initTableAndMap resp.fileType, fileContent

                    # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                    $timeout ->
                        Progress.setMessage ""
                        $location.path editorPath

                .error (resp) ->
                    $log.error "ImportCtrl load file by url error called"
                    $log.debug
                        resp: resp

                    $timeout ->
                        Progress.setMessage ""

                    $translate('TOAST_MESSAGES.READ_ERROR_LINK')
                    .then (translation) ->
                        ngToast.create(
                            content: translation
                            className: "danger"
                        )

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            $log.info "ImportCtrl getFile called"

            # Can't use file.type because of chromes File API
            fileType = $scope.file.name.split "."
            fileType = fileType[fileType.length - 1]
            fileName = $scope.file.name.toString()
            fileName = fileName.substring 0, fileName.lastIndexOf(".")
            Data.name = fileName

            maxFileSize = 52428800
            if $scope.file.size > maxFileSize
                $log.info "ImportCtrl maxFileSize exceeded"
                $log.debug
                    FileSize: $scope.file.size

                $translate('TOAST_MESSAGES.FILE_SIZE_EXCEEDED', {maxFileSize: maxFileSize / 1048576})
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            if fileType isnt "csv" and fileType isnt "zip"
                $log.info "ImportCtrl data format not supported"
                $log.debug
                    format: fileType

                $translate('TOAST_MESSAGES.NOT_SUPPORTED', { format: fileType })
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                $timeout ->
                    Progress.setMessage message

            Import.readFile($scope.file, fileType).then (fileContent) ->
                $log.info "ImportCtrl Import.readFile promise success called"
                $log.debug
                    fileContent: fileContent

                $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                    Progress.setMessage message

                initTableAndMap fileType, fileContent

                $timeout ->
                    $location.path editorPath

            , (error) ->
                $log.error "ImportCtrl Import.readFile promise error called"
                $log.debug
                    error: error

                $translate('TOAST_MESSAGES.READ_ERROR')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

        initTableAndMap = (fileType, fileContent) ->
            Table.useColumnHeadersFromDataset = true

            switch fileType
                when "csv"
                    Data.metaData.fileType = "csv"
                    dataset = Converter.convertCSV2Arrays fileContent
                    Table.setHeader dataset.shift()
                    Table.setDataset dataset
                    Visualization.recommendDiagram()
                    $location.path editorPath

                when "zip"
                    Data.metaData.fileType = "shp"

                    Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                        $log.info "ImportCtrl Converter.convertSHP2GeoJSON promise success called"
                        $log.debug
                            fileContent: fileContent

                        dataset = Converter.convertGeoJSON2Arrays geoJSON

                        if dataset.length
                            Table.setDataset dataset
                            Map.setGeoJSON geoJSON
                            $location.path editorPath

                        else
                            $log.error "ImportCtrl Converter.convertGeoJSON2Arrays error"
                            $log.debug
                                geoJSON: geoJSON

                            $translate('TOAST_MESSAGES.GEOJSON2ARRAYS_ERROR')
                                .then (translation) ->
                                    ngToast.create
                                        content: translation
                                        className: "danger"

                    , (error) ->
                        $log.error "ImportCtrl Converter.convertSHP2GeoJSON promise error called"
                        $log.debug
                            error: error

                        $translate('TOAST_MESSAGES.SHP2GEOJSON_ERROR')
                            .then (translation) ->
                                ngToast.create
                                    content: translation
                                    className: "danger"
]
