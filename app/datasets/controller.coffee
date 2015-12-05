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
            console.log data
            dataAll = data
            $log.info("DataFactory.get called")
            $log.debug
                id: testId
                name: data.name

            created = new Date dataAll.createdAt
            updated = "-"

            if dataAll.updatedAt
                updated = new Date dataAll.updatedAt
                updated = updated.toLocaleString()


            $(document).ready ->
                $('.dataset-title').text dataAll.name
                $('.dataset-creator').text dataAll.userId
                $('.dataset-created').text created.toLocaleString()
                $('.dataset-update').text updated


        #DataFactory.get { id: dataAll.userId }, (data) ->
        #    console.log "user " + data


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
