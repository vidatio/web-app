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
    "$stateParams"
    "$state"
    "$location"
    ($scope, CatalogFactory, $log, DataFactory, $timeout, Progress, Table, $translate, ngToast, $stateParams, $state, $location) ->
        $scope.filter =
            dates:
                from: undefined
                to: undefined
            category: ""
            showMyVidatios: if $stateParams?.myvidatios? then if $stateParams.myvidatios is "true" then true else false

        $(".tagsinput").tagsinput()

        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        $('#my-vidatio-checkbox').radiocheck()

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

                tags = []
                for tag in vidatio.metaData?.tags
                    tags.push tag.name

                vidatio.metaData?.tags = tags

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

        $scope.toggleMyVidatios = ->
            $state.go $state.current, {myvidatios: $scope.filter.showMyVidatios},
                notify: false
                reload: $state.current
]
