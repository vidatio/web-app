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
    ($scope, $rootScope, $log, DataFactory, UserFactory, Table, Map, Converter, $timeout, Progress, $stateParams) ->

        # use datasetId from $stateParams
        datasetId = $stateParams.id
        $scope.information = []

        # get dataset according to datasetId (if possible) and set necessary metadata
        DataFactory.get { id: datasetId }, (data) ->
            $scope.data = data
            updated = convertDates($scope.data.updatedAt)
            created = convertDates($scope.data.createdAt)
            tags = $scope.data.tags || "-"
            format = "JSON"
            category = $scope.data.category || "-"
            userName = $scope.data.userId || "-"
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
                data: $scope.data.data[0]

            # the API-call receives data in GeoJSON, so convert it back in array-format
            dataset = Converter.convertGeoJSON2Arrays $scope.data.data[0]

            # call necessary Table- and Map-functions to display dataset in editor
            Table.resetDataset()
            Table.resetColHeaders()
            Table.setDataset dataset
            Map.setGeoJSON $scope.data.data[0]

            $timeout ->
                Progress.setMessage ""

        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"

        $scope.downloadImage = ->
            $log.info "DatasetCtrl downloadImage called"

        $scope.getLinkDataset = ->
            $log.info "DatasetCtrl getLinkDataset called"

        # convert available dates to locale date-format and display only the date (without time)
        convertDates = (date) ->
            if date == undefined
                return "-"

            current = (new Date date).toLocaleString()
            current = current.split ','
            return current[0]
]
