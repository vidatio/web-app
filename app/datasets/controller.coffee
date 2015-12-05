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
    ($scope, $rootScope, $log, DataFactory, UserFactory) ->

        testId = "565b48985b4c70ae2a34242b"
        dataAll = {}

        DataFactory.get { id: testId }, (data) ->
            dataAll = data
            $log.info("DataFactory.get called")
            $log.debug
                id: testId
                name: data.name

            updated = "-"
            created = "-"

            convertDates = (current) ->
                current = new Date dataAll.createdAt
                current = current.toLocaleString()
                current = current.split ','
                return current[0]

            if dataAll.createdAt
                created = convertDates(dataAll.createdAt)

            if dataAll.updatedAt
                updated convertDates(dataAll.updatedAt)

            $(document).ready ->
                $('.dataset-title').text dataAll.name
                $('.dataset-creator').text dataAll.userId
                $('.dataset-created').text created
                $('.dataset-update').text updated


        #UserFactory.query null, (response) ->
        #   console.log response


        $scope.editDataset = ->
            $log.info "DatasetCtrl editDataset called"
            $log.debug
                id: testId
                name: dataAll.name
                data: dataAll.data


        $scope.shareDataset = ->
            $log.info "DatasetCtrl shareDataset called"

        $scope.downloadDataset = ->
            $log.info "DatasetCtrl downloadDataset called"

        $scope.getLinkDataset = ->
            $log.info "DatasetCtrl getLinkDataset called"

        $scope.getCodeDataset = ->
            $log.info "DatasetCtrl getCodeDataset called"

        $scope.getMetadataDataset = ->
            $log.info "DatasetCtrl getMetadataDataset called"


]
