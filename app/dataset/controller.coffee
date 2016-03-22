# Dataset detail-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$http"
    "$scope"
    "$rootScope"
    "$log"
    "DataFactory"
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
    ($http, $scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams, $location, $translate, ngToast, Data, Visualization) ->
        $scope.downloadCSV = Data.downloadCSV
        $scope.downloadJPEG = Data.downloadJPEG
        $scope.link = $location.$$absUrl

        $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
            Progress.setMessage message

            # get dataset according to datasetId and set necessary metadata
            DataFactory.get {id: $stateParams.id}, (data) ->
                $scope.data = data
                $scope.data.id = $stateParams.id
                $scope.data.created = new Date(data.createdAt)
                $scope.data.creator = data.userId.name || "-"
                $scope.data.origin = "Vidatio"
                $scope.data.updated = new Date(data.updatedAt)
                $scope.data.description = data.description || "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."
                $scope.data.parent = data.parentId
                $scope.data.category = data.category || "-"
                $scope.data.tags = data.tags || "-"

                Data.createVidatio $scope.data

                if Data.meta.fileType isnt "shp"
                    Visualization.create()

                $timeout ->
                    Progress.setMessage()

            # console.log $scope.data, Visualization.options, Table.dataset, Table.header, Map.geoJSON
        , (error) ->
            $log.info "DatasetCtrl error on get dataset from id"
            $log.error error

            $timeout ->
                Progress.setMessage()

            $translate("TOAST_MESSAGES.DATASET_COULD_NOT_BE_LOADED").then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        # @method $scope.openInEditor
        # @description set the vidatio options from saved dataset
        $scope.openInEditor = ->
            $log.info "DatasetCtrl $scope.createVidatio called"

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                Progress.setMessage message
                Data.createVidatio $scope.data

        # toggle link-box with vidatio-link
        $scope.toggleVidatioLink = ->
            $log.info "DatasetCtrl getVidatioLink called"
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
