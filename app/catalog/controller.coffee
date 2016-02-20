"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "DataFactory"
    "$timeout"
    "ProgressService"
    "TableService"
    "$translate"
    "ngToast"
    ($scope, CatalogFactory, $log, DataFactory, $timeout, Progress, Table, $translate, ngToast) ->

        $scope.dates =
            from: undefined
            to: undefined
            maxDate: moment.tz('UTC').hour(12).startOf('h')

        $scope.maxDate = $scope.dates.maxDate

        CatalogFactory.query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            for vidatio in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)
        , (error) ->
            $log.info "CatalogCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        # create a new Vidatio and get necessary data
        $scope.createVidatio = (datasetId) ->

            # get dataset according to datasetId (if possible)
            DataFactory.get { id: datasetId }, (data) ->
                $scope.data = data

                $log.info "CatalogCtrl createVidatio called"
                $log.debug
                    id: datasetId
                    name: $scope.data.name
                    data: $scope.data.data

                Table.setDataset $scope.data.data

                $timeout ->
                    Progress.setMessage ""

            , (error) ->
                $log.info "CatalogCtrl error on get dataset from id"
                $log.error error

                $translate('TOAST_MESSAGES.DATASET_COULD_NOT_BE_LOADED').then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"
]
