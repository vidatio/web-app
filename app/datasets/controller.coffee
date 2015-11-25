# Dataset-view Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "DatasetCtrl", [
    "$scope"
    "$rootScope"
    "$log"
    ($scope, $rootScope, $log) ->

        $scope.editDataset = ->
            $log.info "DatasetCtrl editDataset called"

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
