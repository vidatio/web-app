"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "DatasetsFactory"
    "$log"
    ($scope, DatasetsFactory, $log) ->
        DatasetsFactory.datasetsLimit { "limit": 3 }, (response) ->
            $scope.newestVidatios = response

            for vidatio in $scope.newestVidatios
                # prevent that one of the newest vidatios has no image
                if vidatio.visualizationOptions?.thumbnail and vidatio.visualizationOptions.thumbnail isnt "data:,"
                        vidatio.image = vidatio.visualizationOptions.thumbnail
                else
                    vidatio.image = "images/logo-text-black.svg"

        , (error) ->
            $log.info "IndexCtrl error on query newest datasets"
            $log.error error
]
