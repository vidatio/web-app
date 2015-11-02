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
    "ProgressOverlayService"
    ($scope, $http, $location, $log, $rootScope, $timeout, $translate, Import, Table, Converter, Map, Data, ngToast, ProgressOverlay) ->
        $scope.link = "http://data.stadt-salzburg.at/geodaten/wfs?service=WFS&version=1.1.0&request=GetFeature&"+
                "srsName=urn:x-ogc:def:crs:EPSG:4326&outputFormat=csv&typeName=ogdsbg:volksschule"

        $scope.importService = Import
        editorPath = "/" + $rootScope.locale + "/editor"

        $scope.continueToEmptyTable = ->
            $log.info "ImportCtrl continueToEmptyTable called"

            Table.resetDataset()
            Table.resetColHeaders()
            Map.resetGeoJSON()

            # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
            $timeout ->
                $location.path editorPath

        # Read via link
        $scope.load = ->
            $log.info "ImportCtrl load called"

            url = $scope.link
            $http.get($rootScope.apiBase + "/v0/import"
                params:
                    url: url
            ).success (data) ->

                $log.info "ImportCtrl load success called"
                $log.debug
                    message: "ImportCtrl load success called"
                    data: data

                Table.setDataset data

                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    $location.path editorPath
            .error (data) ->
                $log.error "ImportCtrl load file by url error called"
                $log.debug error: error

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
            Data.meta.fileName = fileName

            maxFileSize = 52428800
            if $scope.file.size > maxFileSize
                $translate('TOAST_MESSAGES.FILE_SIZE_EXCEEDED', {maxFileSize: maxFileSize / 1048576})
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            if fileType isnt "csv" and fileType isnt "zip"
                $translate('TOAST_MESSAGES.NOT_SUPPORTED', { format: fileType })
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                ProgressOverlay.setMessage message

            ProgressOverlay.setMessage $translate.instant("OVERLAY_MESSAGES.READING_FILE")

            Import.readFile($scope.file, fileType).then (fileContent) ->
                $log.info "ImportCtrl Import readFile promise success called"
                $log.debug
                    message: "ImportCtrl Import readFile promise success called"
                    fileContent: fileContent

                $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                    ProgressOverlay.setMessage message

                switch fileType

                    when "csv"
                        Data.meta.fileType = "csv"
                        dataset = Converter.convertCSV2Arrays fileContent
                        geoJSON = Converter.convertArrays2GeoJSON dataset
                        Table.resetColHeaders()
                        Table.setDataset dataset
                        Map.setGeoJSON geoJSON
                        $location.path editorPath

                    when "zip"
                        Data.meta.fileType = "shp"
                        Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                            $log.info "ImportCtrl Converter convertSHP2GeoJSON promise success called"
                            $log.debug
                                message: "ImportCtrl Converter convertSHP2GeoJSON promise success called"
                                fileContent: fileContent

                            Converter.convertGeoJSON2Arrays(geoJSON).then (dataset) ->
                                colHeaders = Converter.convertGeoJSON2ColHeaders geoJSON
                                Table.setDataset dataset
                                Table.setColHeaders colHeaders
                                Map.setGeoJSON geoJSON
                                $location.path editorPath
                            , (error) ->
                                $log.info "Converter convertGeoJSON2Arrays promise error called"
                                $log.debug
                                    message: "Converter convertGeoJSON2Arrays promise error called"
                                    error: error
                                $log.error "Converter convertGeoJSON2Arrays promise error called"

                                $translate('TOAST_MESSAGES.GEOJSON2ARRAYS_ERROR')
                                    .then (translation) ->
                                        ngToast.create
                                            content: translation
                                            className: "danger"

                        , (error) ->
                            $log.info "Converter convertSHP2GeoJSON promise error called"
                            $log.debug
                                message: "Converter convertSHP2GeoJSON promise error called"
                                error: error
                            $log.error "Converter convertSHP2GeoJSON promise error called"

                            $translate('TOAST_MESSAGES.SHP2GEOJSON_ERROR')
                                .then (translation) ->
                                    ngToast.create
                                        content: translation
                                        className: "danger"


                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    ProgressOverlay.setMessage ""

            , (error) ->
                $log.info "ImportCtrl Import readFile promise error called"
                $log.debug
                    message: "ImportCtrl Import readFile promise error called"
                    error: error
                $log.error "ImportCtrl Import.readFile error"

                $translate('TOAST_MESSAGES.READ_ERROR')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
]
