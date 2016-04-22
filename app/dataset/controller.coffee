# Dataset detail-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$http"
    "$scope"
    "$rootScope"
    "$log"
    "DatasetFactory"
    "UserFactory"
    "TableService"
    "MapService"
    "ConverterService"
    "$timeout"
    "ProgressService"
    "$stateParams"
    "$location"
    "$translate"
    "ngToast"
    "DataService"
    "VisualizationService"
    "ErrorHandler"
    ($http, $scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams, $location, $translate, ngToast, Data, Visualization, ErrorHandler) ->
        $scope.downloadCSV = Data.downloadCSV
        $scope.link = $location.$$absUrl

        $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
            Progress.setMessage message

            # get dataset according to datasetId and set necessary metadata
            DataFactory.get {id: $stateParams.id}, (data) ->
                $scope.data = data
                $scope.data.updated = new Date($scope.data.updatedAt)
                $scope.data.created = new Date($scope.data.createdAt)

                if $scope.data.metaData.tagIds?
                    $scope.data.tags = vidatio.helper.flattenArray $scope.data.metaData.tagIds, "name"
#                    for tag in $scope.data.metaData.tagIds
#                        $scope.data.tags.push tag.name

                $scope.data.category = if $scope.data.metaData.categoryId?.name? then $scope.data.metaData.categoryId.name else "-"
                $scope.data.userName = if $scope.data.metaData.userId?.name? then $scope.data.metaData.userId.name else "-"
                $scope.data.author = if $scope.data.metaData.author? then $scope.data.metaData.author else "-"
                $scope.data.title = $scope.data.metaData.name || "Vidatio"

                Data.useSavedData $scope.data

                options = $scope.data.visualizationOptions
                options.fileType = if $scope.data.metaData?.fileType? then $scope.data.metaData.fileType else "csv"

                Visualization.create(options)
                Progress.setMessage()
            , (error) ->
                Progress.setMessage()
                ErrorHandler.format error

        # @method $scope.openInEditor
        # @description open dataset in Editor
        $scope.openInEditor = ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message

        #@method $scope.downloadVisualization
        #@description exports a
        #@params {string} type
        $scope.downloadVisualization = (type) ->
            $log.info "DatasetCtrl downloadVisualization called"
            $log.debug
                type: type

            fileName = $scope.data.title + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            Visualization.downloadAsImage fileName, type

        #@method $scope.downloadCSV
        #@description downloads the dataset in csv-format
        $scope.downloadCSV = ->
            Data.downloadCSV $scope.data.title

        #@method $scope.setBoundsToGeoJSON
        #@description recenters map to intial view of the map
        $scope.setBoundsToGeoJSON = ->
            Map.setBoundsToGeoJSON()
]
