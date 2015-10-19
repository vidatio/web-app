# Import Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ImportCtrl", [
    "$scope"
    "$http"
    "$location"
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
    ($scope, $http, $location, $rootScope, $timeout, $translate, Import, Table, Converter, Map, Data, ngToast, ProgressOverlay) ->
        $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv"

        $scope.importService = Import

        editorPath = "/" + $rootScope.locale + "/editor"

        $scope.continueToEmptyTable = ->
            Table.resetDataset()
            Table.resetColHeaders()
            Map.resetGeoJSON()

            # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
            $timeout ->
                $location.path editorPath

        # Read via link
        $scope.load = ->
            url = $scope.link
            $http.get($rootScope.apiBase + "/v0/import"
                params:
                    url: url
            ).success (data) ->
                Table.setDataset data

                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    $location.path editorPath

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            # Can't use file.type because of chromes File API

            fileType = $scope.file.name.split "."
            fileType = fileType[fileType.length - 1]

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

            Import.readFile($scope.file, fileType).then (fileContent) ->
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

                    when "zip"
                        Data.meta.fileType = "shp"
                        Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                            dataset = Converter.convertGeoJSON2Arrays geoJSON
                            colHeaders = Converter.convertGeoJSON2ColHeaders geoJSON
                            Table.setDataset dataset
                            Table.setColHeaders colHeaders
                            Map.setGeoJSON geoJSON

                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    ProgressOverlay.setMessage ""
                    $location.path editorPath

            , (error) ->
                console.log error
]
