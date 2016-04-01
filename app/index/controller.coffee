"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "DatasetsFactory"
    "$log"
    ($scope, DatasetsFactory, $log) ->
        DatasetsFactory.datasetsLimit { "limit": 3 }, (response) ->
            $scope.newestVidatios = response

            for vidatio, index in $scope.newestVidatios
                if index is 0
                    vidatio.image = "images/newest-vidatios-placeholder.png"
                else if index is 1
                    vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                else
                    vidatio.image = "images/placeholder-featured-vidatios-buchungsstatistik-pongau.svg"

        , (error) ->
            $log.info "IndexCtrl error on query newest datasets"
            $log.error error
]
