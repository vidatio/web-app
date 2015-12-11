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
    ($scope, $http, $location, $log, $rootScope, $timeout, $translate, Import, Table, Converter, Map, Data, ngToast, Progress) ->
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
                $log.debug
                    message: "ImportCtrl load file by url error called"
                    error: error

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
                $log.info
                    message: "ImportCtrl maxFileSize exceeded"
                    FileSize: $scope.file.size

                $translate('TOAST_MESSAGES.FILE_SIZE_EXCEEDED', {maxFileSize: maxFileSize / 1048576})
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            if fileType isnt "csv" and fileType isnt "zip"
                $log.info
                    message: "ImportCtrl data format not supported"
                    Format: fileType

                $translate('TOAST_MESSAGES.NOT_SUPPORTED', { format: fileType })
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )
                return

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                Progress.setMessage message

            Import.readFile($scope.file, fileType).then (fileContent) ->
                $log.info "ImportCtrl Import.readFile promise success called"
                $log.debug
                    message: "ImportCtrl Import.readFile promise success called"
                    fileContent: fileContent

                $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                    Progress.setMessage message

                switch fileType

                    when "csv"
                        Data.meta.fileType = "csv"

                        dataset = Converter.convertCSV2Arrays fileContent
                        subDataset = Helper.cutDataset(dataset)

                        { recommendedDiagram, xColumn, yColumn } = Recommender.getRecommendedDiagram(subDataset)

                        switch recommendedDiagram
                            when "scatter"
                                $log.info "ImportCtrl decided to draw a scatter plot"

                            when "map"
                                $log.info "ImportCtrl decided to draw a map"
                                geoJSON = Converter.convertArrays2GeoJSON dataset
                                Map.setGeoJSON geoJSON

                            when "parallel"
                                $log.info "ImportCtrl decided to draw parallel coordinates"

                            when "bar"
                                $log.info "ImportCtrl decided to draw a bar chart"

                            when "line"
                                $log.info "ImportCtrl decided to draw a line chart"

                            else
                                $log.error "ImportCtrl recommend diagram failed, dataset isn't usable with vidatio"

                        Table.resetColHeaders()
                        Table.setDataset dataset

                        $location.path editorPath

                    when "zip"
                        Data.meta.fileType = "shp"
                        Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                            $log.info "ImportCtrl Converter.convertSHP2GeoJSON promise success called"
                            $log.debug
                                message: "ImportCtrl Converter.convertSHP2GeoJSON promise success called"
                                fileContent: fileContent

                            dataset = Converter.convertGeoJSON2Arrays geoJSON

                            if dataset.length
                                colHeaders = Converter.convertGeoJSON2ColHeaders geoJSON
                                Table.setDataset dataset
                                Table.setColHeaders colHeaders
                                Map.setGeoJSON geoJSON
                                $location.path editorPath

                            else
                                $log.info "ImportCtrl Converter.convertGeoJSON2Arrays error"
                                $log.debug
                                    message: "ImportCtrl Converter.convertGeoJSON2Arrays error"
                                    geoJSON: geoJSON
                                $log.error "ImportCtrl Converter.convertGeoJSON2Arrays error"

                                $translate('TOAST_MESSAGES.GEOJSON2ARRAYS_ERROR')
                                    .then (translation) ->
                                        ngToast.create
                                            content: translation
                                            className: "danger"

                        , (error) ->
                            $log.info "ImportCtrl Converter.convertSHP2GeoJSON promise error called"
                            $log.debug
                                message: "ImportCtrl Converter.convertSHP2GeoJSON promise error called"
                                error: error
                            $log.error "ImportCtrl Converter.convertSHP2GeoJSON promise error called"

                            $translate('TOAST_MESSAGES.SHP2GEOJSON_ERROR')
                                .then (translation) ->
                                    ngToast.create
                                        content: translation
                                        className: "danger"


                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    Progress.setMessage ""
                    $location.path editorPath

            , (error) ->
                $log.info "ImportCtrl Import.readFile promise error called"
                $log.debug
                    message: "ImportCtrl Import.readFile promise error called"
                    error: error
                $log.error "ImportCtrl Import.readFile error"

                $translate('TOAST_MESSAGES.READ_ERROR')
                    .then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
]
