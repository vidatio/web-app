# Dataset detail-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DetailviewCtrl", [
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

        datasetId = $stateParams.id
        $scope.information = []

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
            image = $scope.data.image || "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
            description = $scope.data.description || "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur."

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
                data: $scope.data
                format: format

        , (error) ->
            console.error error

        #UserFactory.query null, (response) ->
        #   console.log response

        $scope.editDataset = ->
            $log.info "DetailviewCtrl editDataset called"
            $log.debug
                id: datasetId
                name: $scope.data.name
                data: $scope.data.data

            # the API-call receives data in GeoJSON, so convert it back in array-format
            dataset = Converter.convertGeoJSON2Arrays $scope.data.data

            # call necessary Table- and Map-functions to display dataset in editor
            Table.resetDataset()
            Table.resetColHeaders()
            Table.setDataset dataset
            Map.setGeoJSON $scope.data.data

            $timeout ->
                Progress.setMessage ""

        $scope.shareDataset = ->
            $log.info "DetailviewCtrl shareDataset called"

        $scope.downloadDataset = ->
            $log.info "DetailviewCtrl downloadDataset called"

        $scope.downloadImage = ->
            $log.info "DetailviewCtrl downloadImage called"

        $scope.getLinkDataset = ->
            $log.info "DetailviewCtrl getLinkDataset called"

        $scope.getCodeDataset = ->
            $log.info "DetailviewCtrl getCodeDataset called"

        $scope.getMetadataDataset = ->
            $log.info "DetailviewCtrl getMetadataDataset called"

        # convert available dates to locale date-format and display only the date without time
        convertDates = (date) ->
            if date == undefined
                return "-"

            current = (new Date date).toLocaleString()
            current = current.split ','
            return current[0]
]
