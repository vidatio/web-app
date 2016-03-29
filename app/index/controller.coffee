"use strict"

app = angular.module "app.controllers"

app.controller "IndexCtrl", [
    "$scope"
    "DatasetsFactory"
    "$log"
    "$translate"
    "ngToast"
    ($scope, DatasetsFactory, $log, $translate, ngToast) ->
        DatasetsFactory.datasetsLimit { "limit": 3 }, (response) ->
            #"/datasets?limit=3"
            console.log response
            $log.info "IndexCtrl successfully queried datasets"

            $scope.newestVidatios = response.slice(0, 3)

            for vidatio, index in $scope.newestVidatios
                if index is 0
                    vidatio.image = "images/newest-vidatios-placeholder.png"
                else if index is 1
                    vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                else
                    vidatio.image = "images/placeholder-featured-vidatios-buchungsstatistik-pongau.svg"

        , (error) ->
            $log.info "IndexCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"
]
