"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "$translate"
    "ngToast"
    ($scope, CatalogFactory, $log, $translate, ngToast) ->
        CatalogFactory.getDatasets().query (response) ->
            $log.info "IndexCtrl successfully queried datasets"

            $scope.newestVidatios = response.slice(0, 3)

            counter = 0

            for vidatio in $scope.newestVidatios
                if counter is 0
                    vidatio.image = "images/newest-vidatios-placeholder.png"
                else if counter is 1
                    vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                else
                    vidatio.image = "images/placeholder-featured-vidatios-buchungsstatistik-pongau.svg"

                counter++

        , (error) ->
            $log.info "IndexCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"
]
