# Dataset detail-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
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
    ($scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams, $location, $translate, ngToast, Data, Visualization) ->

        # set link to current vidatio
        $rootScope.link = $location.$$absUrl

        # link-overlay shouldn't be displayed on detailviews' start
        $rootScope.showVidatioLink = false

        # use datasetId from $stateParams
        datasetId = $stateParams.id
        $scope.information = []

        # get dataset according to datasetId and set necessary metadata
        DataFactory.get { id: datasetId }, (data) ->
            $scope.data = data
            updated = new Date($scope.data.updatedAt)
            created = new Date($scope.data.createdAt)
            Data.meta["fileType"] = $scope.data.metaData.fileType || "-"
            if data.options?
                Visualization.diagramType = data.options.diagramType || false
                Visualization.xAxisCurrent = data.options.xAxisCurrent || 0
                Visualization.yAxisCurrent = data.options.yAxisCurrent || 1
                Visualization.color = data.options.color || "#11DDC6"
                Visualization.selectedDiagramName = data.options.selectedDiagramName || null
            tags = $scope.data.tags || "-"
            category = $scope.data.category || "-"
            dataOrigin = "Vidatio"
            userName = $scope.data.userId.name || "-"
            title = $scope.data.name || "Vidatio"
            parent = $scope.data.parentId || "-"
            image = $scope.data.image || "images/logo-greyscale.svg"
            description = $scope.data.description || "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

            # fill up detail-view with metadata
            $scope.information.push
                title: title
                image: image
                id: datasetId
                created: created
                creator: userName
                origin: dataOrigin
                updated: updated
                description: description
                parent: parent
                category: category
                tags: tags

        , (error) ->
            $log.info "DatasetCtrl error on get dataset from id"
            $log.error error

            $translate("TOAST_MESSAGES.DATASET_COULD_NOT_BE_LOADED").then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        # @method $scope.createVidatio
        # @description creates Vidatio from saved Dataset
        $scope.createVidatio = ->
            $log.info "DatasetCtrl createVidatio called"
            $log.debug
                id: datasetId
                name: $scope.data.name
                data: $scope.data.data

            $translate("OVERLAY_MESSAGES.READING_FILE").then (message) ->
                Progress.setMessage message

            #TODO: Header need to be initialized from database.

            if Data.meta["fileType"] is "shp"
                dataset = Converter.convertGeoJSON2Arrays $scope.data.data
                console.log "dataset", dataset
                Table.setDataset dataset
                Table.useColumnHeadersFromDataset = true
                Map.setGeoJSON $scope.data.data
                console.log "geoJSON", $scope.data.data
            else
                Table.setDataset $scope.data.data
                Table.useColumnHeadersFromDataset = true

            $timeout ->
                Progress.setMessage ""

        # at the moment direct download is not possible, so download via editor
        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"
            @createVidatio()

        $scope.downloadImage = ->
            $log.info "DatasetCtrl downloadImage called"
            @createVidatio()

        # toggle link-box with vidatio-link
        $scope.toggleVidatioLink = ->
            $log.info "DatasetCtrl getVidatioLink called"
            $log.debug
                id: datasetId
                link: $rootScope.link

            $rootScope.showVidatioLink = if $rootScope.showVidatioLink then false else true

        # hide link-box if necessary
        $scope.hideVidatioLink = ->
            $rootScope.showVidatioLink = false

        # copy link to clipboard
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
