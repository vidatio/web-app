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
    ($scope, CatalogFactory, $log, DataFactory, $timeout, Progress, Table) ->

        CatalogFactory.query (response) ->
            $scope.vidatios = response

            for vidatio in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
        , (error) ->
            console.error error

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
                console.error error
]
