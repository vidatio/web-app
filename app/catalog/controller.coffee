"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "$translate"
    "ngToast"
    ($scope, CatalogFactory, $log, $translate, ngToast) ->

        $scope.filter =
            dates:
                from: undefined
                to: undefined
            category: undefined

        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        categories = [
            "Politik"
            "Sport"
            "Umwelt"
            "Bildung"
            "Finanzen"
        ]

        CatalogFactory.getCategories().query (response) ->
            $log.info "CatalogCtrl successfully queried categories"
            $scope.categories = response
            console.log("CATEGORIES", response)

        CatalogFactory.getDatasets().query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            for vidatio, index in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)
                vidatio.metaData =
                    category: categories[ index % categories.length ]
        , (error) ->
            $log.info "CatalogCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

]
