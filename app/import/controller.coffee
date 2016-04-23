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
    "TableService"
    "ConverterService"
    "MapService"
    "DataService"
    "ImportService"
    "ngToast"
    "ProgressService"
    "VisualizationService"
    "ErrorHandler"
    "$q"
    ($scope, $http, $location, $log, $rootScope, $timeout, $translate, Table, Converter, Map, Data, Import, ngToast, Progress, Visualization, ErrorHandler, $q) ->
        $scope.link = "http://data.ooe.gv.at/files/cms/Mediendateien/OGD/ogd_abtStat/Wahl_LT_09_OGD.csv"

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
            Progress.setMessage $translate.instant("OVERLAY_MESSAGES.PARSING_DATA")

            $http.get($rootScope.apiBase + "/v0/forward"
                params:
                    url: $scope.link
            ).success (resp) ->
                fileContent = if resp.fileType is 'zip' then resp.body.data else resp.body
                Data.initTableAndMap resp.fileType, fileContent

                # REFACTOR Needed to wait for leaflet directive to reset its geoJSON
                $timeout ->
                    $state.go "app.editor"

            .error (resp) ->
                $log.error "ImportCtrl load file by url error called"
                $log.debug
                    resp: resp

                Progress.resetMessage()
                ErrorHandler.format resp

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = (file) ->
            Import.getFile file
]
