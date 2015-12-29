# Dataset-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    "DataFactory"
    "UserFactory"
    "DatasetService"
    "TableService"
    "MapService"
    "ConverterService"
    "$timeout"
    "ProgressService"
    ($scope, $rootScope, $log, DataFactory, UserFactory, DatasetService, Table, Map, Converter, $timeout, Progress) ->

        testId = "565b48985b4c70ae2a34242b"
        $scope.information = []

        DataFactory.get { id: testId }, (data) ->
            $scope.data = data
            updated = convertDates($scope.data.updatedAt)
            created = convertDates($scope.data.createdAt)
            datasetId = $scope.data._id || "-"
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

        #UserFactory.query null, (response) ->
        #   console.log response


        $scope.editDataset = ->
            $log.info "DatasetCtrl editDataset called"
            $log.debug
                id: testId
                name: $scope.data.name
                data: $scope.data.data

            # the API-call receives gata in GeoJSON, so convert it back in array-format
            dataset = Converter.convertGeoJSON2Arrays $scope.data.data

            # call necessary Table- and Map-functions to display dataset in editor
            Table.resetDataset()
            Table.resetColHeaders()
            Table.setDataset dataset
            Map.setGeoJSON $scope.data.data

            $timeout ->
                Progress.setMessage ""


        $scope.shareDataset = ->
            $log.info "DatasetCtrl shareDataset called"

            DatasetService.share($scope.data.data)

        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"

            DatasetService.downloadDataset($scope.data.data)


        $scope.getLinkDataset = ->
            $log.info "DatasetCtrl getLinkDataset called"

            DatasetService.getLink($scope.data.link)


        $scope.getCodeDataset = ->
            $log.info "DatasetCtrl getCodeDataset called"

            DatasetService.downloadCode($scope.data)


        $scope.getMetadataDataset = ->
            $log.info "DatasetCtrl getMetadataDataset called"

            DatasetService.downloadMetadata($scope.data)


        convertDates = (date) ->

            if date == undefined
                return "-"

            current = (new Date date).toLocaleString()
            current = current.split ','
            return current[0]
]
