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
    "ErrorHandler"
    "$q"
    "$state"
    ($scope, $http, $location, $log, $rootScope, $timeout, $translate, Import, Table, Converter, Map, Data, ngToast, Progress, Visualization, ErrorHandler, $q, $state) ->
        $scope.link = "http://data.ooe.gv.at/files/cms/Mediendateien/OGD/ogd_abtStat/Wahl_LT_09_OGD.csv"
        $scope.importService = Import

        $scope.continueToEmptyTable = ->
            Data.datasetID = null
            Data.metaData.fileType = "csv"
            Table.useColumnHeadersFromDataset = false
            Visualization.resetOptions()
            Table.setDataset()
            Map.resetGeoJSON()

            # REFACTOR Need to wait for leaflet directive to reset its geoJSON
            $timeout ->
                $state.go "app.editor"

        # Read via link
        $scope.load = ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message

                url = $scope.link
                $http.get($rootScope.apiBase + "/v0/forward"
                    params:
                        url: url
                ).success (resp) ->
                    fileContent = if resp.fileType is 'zip' then resp.body.data else resp.body
                    initTableAndMap resp.fileType, fileContent

                    # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                    $timeout ->
                        Progress.setMessage ""
                        $state.go "app.editor"

                .error (resp) ->
                    $log.error "ImportCtrl load file by url error called"
                    $log.debug
                        resp: resp

                    Progress.resetMessage()
                    ErrorHandler.format resp

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                Progress.setMessage message

            # Can't use file.type because of chromes File API
            fileType = $scope.file.name.split "."
            fileType = fileType[fileType.length - 1]
            fileName = $scope.file.name.toString()
            fileName = fileName.substring 0, fileName.lastIndexOf(".")
            Data.name = fileName

            maxFileSize = 52428800
            if $scope.file.size > maxFileSize
                $log.warn "ImportCtrl maxFileSize exceeded"
                $log.debug
                    fileSize: $scope.file.size

                $translate('TOAST_MESSAGES.FILE_SIZE_EXCEEDED', {maxFileSize: maxFileSize / 1048576})
                .then (translation) ->
                    Progress.resetMessage()
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
                    Progress.resetMessage()
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            Import.readFile($scope.file, fileType).then (fileContent) ->
                $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                    Progress.setMessage message

                initTableAndMap fileType, fileContent

            , (error) ->
                $log.error "ImportCtrl Import.readFile promise error called"
                $log.debug
                    error: error

                Progress.resetMessage()

                $translate('TOAST_MESSAGES.READ_ERROR')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"

        initTableAndMap = (fileType, fileContent) ->
            Data.datasetID = null

            deferred = $q.defer()
            promise = deferred.promise

            Table.useColumnHeadersFromDataset = true

            switch fileType
                when "csv"
                    Data.metaData.fileType = "csv"
                    dataset = Converter.convertCSV2Arrays fileContent
                    Table.setHeader dataset.shift()
                    Table.setDataset dataset
                    Visualization.useRecommendedOptions()
                    deferred.resolve()

                when "zip"
                    Data.metaData.fileType = "shp"

                    Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                        dataset = Converter.convertGeoJSON2Arrays geoJSON

                        if dataset.length
                            Table.setDataset dataset
                            Table.useColumnHeadersFromDataset = true
                            Visualization.options.type = "map"
                            Map.setGeoJSON geoJSON
                            deferred.resolve()
                        else
                            deferred.reject
                                i18n: "TOAST_MESSAGES.GEOJSON2ARRAYS_ERROR"

                    , (error) ->
                        $log.error "ImportCtrl Converter.convertSHP2GeoJSON promise error called"
                        $log.debug
                            error: error

                        deferred.reject
                            i18n: "TOAST_MESSAGES.SHP2GEOJSON_ERROR"

            promise.then ->
                $state.go "app.editor"

            .catch (error) ->
                $translate(error.i18n).then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

                    Progress.resetMessage()

]
