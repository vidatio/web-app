"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "$translate"
    "ngToast"
    ($scope, CatalogFactory, $log, $translate, ngToast) ->

#        $scope.filter =
#            category: null

        tags = [
            ["test", "hallo welt"]
            ["myVidatio", "tag3", "hallo welt"]
            ["tag1", "test"]
            ["tag2", "vidatio"]
            ["tag3", "tag1"]
        ]

        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        CatalogFactory.getCategories().query (response) ->
            $log.info "CatalogCtrl successfully queried categories"
            $scope.categories = response

        CatalogFactory.getDatasets().query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            for vidatio, index in $scope.vidatios
                vidatio.description = "Hello world, this is a test!"
                vidatio.title = vidatio.name
                vidatio.image = "images/placeholder-featured-vidatios-arbeitslosenzahlen-salzburg.svg"
                vidatio.createdAt = new Date(vidatio.createdAt)
                vidatio.metaData.tags = tags[ index % tags.length ]

        , (error) ->
            $log.info "CatalogCtrl error on query datasets"
            $log.error error

            $translate('TOAST_MESSAGES.VIDATIOS_COULD_NOT_BE_LOADED').then (translation) ->
                ngToast.create
                    content: translation
                    className: "danger"

        $scope.setCategory = (category) ->
            vidatio.log.info "CatalogCtrl setCategory called"
            vidatio.log.debug
                category: category
            $scope.filter.category = category

]
