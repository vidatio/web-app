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
    ($scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams, $location, $translate, ngToast) ->

        # link shouldn't be displayed on detailviews start
        $rootScope.showVidatioLink = false

        # use datasetId from $stateParams
        datasetId = $stateParams.id
        $scope.information = []

        # get dataset according to datasetId (if possible) and set necessary metadata
        DataFactory.get { id: datasetId }, (data) ->
            $scope.data = data
            console.log data
            updated = convertDates($scope.data.updatedAt)
            created = convertDates($scope.data.createdAt)
            tags = $scope.data.tags || "-"
            format = "geoJSON"
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
                format: format

        , (error) ->
            console.error error

        $scope.editDataset = ->
            $log.info "DatasetCtrl editDataset called"
            $log.debug
                id: datasetId
                name: $scope.data.name
                data: $scope.data.data

            # the API-call receives data in GeoJSON, so convert it back in array-format
            #dataset = Converter.convertGeoJSON2Arrays $scope.data.data[0]

            # call necessary Table- and Map-functions to display dataset in editor
            #Table.resetDataset()
            #Table.resetColumnHeaders()
            Table.setDataset $scope.data.data
            #Map.setGeoJSON $scope.data.data[0]

            $timeout ->
                Progress.setMessage ""

        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"
            # at the moment direct download s not possible, so download via editor
            $scope.editDataset()

        $scope.downloadImage = ->
            $log.info "DatasetCtrl downloadImage called"
            # at the moment direct download s not possible, so download via editor
            $scope.editDataset()

        $scope.getLinkDataset = ->
            $log.info "DatasetCtrl getLinkDataset called"
            $log.debug
                id: datasetId
                link: $location.$$absUrl

            # toggle link-overlay on click at link-button
            $rootScope.showVidatioLink = if $rootScope.showVidatioLink then false else true
            $rootScope.link = $location.$$absUrl

        $scope.hideLinkToVidatio = ->
            $rootScope.showVidatioLink = false

        # copy link to clipboard
        $scope.copyVidatioLink = ->
            $log.info "DatasetCtrl copyVidatioLink called"
            window.getSelection().removeAllRanges()
            link = document.querySelector '#vidatio-link'
            range = document.createRange()
            range.selectNode link
            window.getSelection().addRange(range)

            try
                successful = document.execCommand 'copy'

                $log.debug
                    message: "DatasetCtrl copy vidatio-link to clipboard"
                    successful: successful

                $translate('TOAST_MESSAGES.LINK_COPIED')
                .then (translation) ->
                    ngToast.create
                        content: translation
            catch error
                $log.info "DatasetCtrl copy vidatio-link could not be copied"
                $log.error
                    error: error

            window.getSelection().removeAllRanges()

        # convert available dates to locale date-format and display only the date (without time)
        convertDates = (date) ->
            if date == undefined
                return "-"

            current = (new Date date).toLocaleString()
            current = current.split ','
            return current[0]
]
