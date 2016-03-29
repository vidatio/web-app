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
    "$window"
    ($http, $scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams, $location, $translate, ngToast, Data, Visualization, $window) ->
        $scope.downloadCSV = Data.downloadCSV
        $scope.downloadJPEG = Data.downloadJPEG
        $scope.visualization = Visualization.options
        $scope.link = $location.$$absUrl
        $scope.geojson = Map.leaflet

        $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
            Progress.setMessage message

            # get dataset according to datasetId and set necessary metadata
            DataFactory.get {id: $stateParams.id}, (data) ->

                $scope.data = data
                $scope.data.updated = new Date($scope.data.updatedAt)
                $scope.data.created = new Date($scope.data.createdAt)
                Data.metaData["fileType"] = if $scope.data.metaData?.fileType? then $scope.data.metaData.fileType else null
                if $scope.data.metaData.tagIds?
                    $scope.data.tags = []
                    for tag in $scope.data.metaData.tagIds
                        $scope.data.tags.push tag.name

                $scope.data.category = if $scope.data.metaData.categoryId?.name? then $scope.data.metaData.categoryId.name else null
                $scope.data.dataOrigin = "Vidatio"
                $scope.data.userName = if $scope.data.metaData.userId?.name? then $scope.data.metaData.userId.name else "-"
                $scope.data.title = $scope.data.name || "Vidatio"

                Data.createVidatio $scope.data

                if Data.meta.fileType isnt "shp"
                    Visualization.create()

                $timeout ->
                    Progress.setMessage()

            , (error) ->
                $log.info "DatasetCtrl error on get dataset from id"
                $log.error error

                $timeout ->
                    Progress.setMessage()

                $translate("TOAST_MESSAGES.DATASET_COULD_NOT_BE_LOADED").then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        # Resizing the visualization
        # using setTimeout to use only to the last resize action of the user
        id = null
        $chart = $("#chart")
        lastWidth = 954 # 954px is the max-width of the viz-container

        onWindowResizeCallback = ->
            currentWidth = $chart.parent().width()

            # resizing should only be done when viz-containers' width changes, return otherwise
            if currentWidth is lastWidth
                return

            clearTimeout id
            id = setTimeout ->
                Visualization.create()
            , 250

            lastWidth = currentWidth

        # resize event only should be fired if user is currently on detailview
        window.angular.element($window).on 'resize', $scope.$apply, onWindowResizeCallback

        # resize watcher has to be removed when detailview is leaved
        $scope.$on '$destroy', ->
            window.angular.element($window).off 'resize', onWindowResizeCallback

        # @method $scope.openInEditor
        # @description open dataset in Editor
        $scope.openInEditor = ->
            $log.info "DatasetCtrl $scope.openInEditor called"

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                Progress.setMessage message
                Data.createVidatio $scope.data

        # toggle link-box with vidatio-link
        $scope.toggleVidatioLink = ->
            $log.info "DatasetCtrl toggleVidatioLink called"
            $log.debug
                link: $scope.link

            $rootScope.showVidatioLink = if $rootScope.showVidatioLink then false else true

        $scope.hideVidatioLink = ->
            $rootScope.showVidatioLink = false

        $scope.copyVidatioLink = ->
            $log.info "DatasetCtrl copyVidatioLink called"

            window.getSelection().removeAllRanges()
            link = document.querySelector "#vidatio-link"
            range = document.createRange()
            range.selectNode link
            window.getSelection().addRange(range)

            try
                successful = document.execCommand "copy"

                $log.debug
                    message: "DatasetCtrl copy vidatio-link to clipboard"
                    successful: successful

                $translate("TOAST_MESSAGES.LINK_COPIED")
                .then (translation) ->
                    ngToast.create
                        content: translation

            catch error
                $log.info "DatasetCtrl vidatio-link could not be copied to clipboard"
                $log.error
                    error: error

                $translate("TOAST_MESSAGES.LINK_NOT_COPIED")
                .then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

            window.getSelection().removeAllRanges()
]
