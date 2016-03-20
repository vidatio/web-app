"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "$log"
    "$timeout"
    "ProgressService"
    "TableService"
    "$translate"
    "ngToast"
    "$stateParams"
    "$state"
    "DatasetsFactory"
    "CategoriesFactory"
    ($scope, $log, $timeout, Progress, Table, $translate, ngToast, $stateParams, $state, DatasetsFactory, CategoriesFactory) ->

        $scope.filter =
            dates:
                from: if $stateParams?.from then moment($stateParams.from, "DD-MM-YYYY") else ""
                to: if $stateParams?.to then moment($stateParams.to, "DD-MM-YYYY") else ""
            category: if $stateParams?.category then $stateParams.category else ""
            tags: if $stateParams?.tags then $stateParams.tags.split("|") else ""
            showMyVidatios: if $stateParams?.myvidatios then if $stateParams.myvidatios is "true" then true else false

        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        $('#my-vidatio-checkbox').radiocheck()

        CategoriesFactory.query (response) ->
            $log.info "CatalogCtrl successfully queried categories"
            $scope.categories = response

        DatasetsFactory.query (response) ->
            $log.info "CatalogCtrl successfully queried datasets"

            $scope.vidatios = response

            for vidatio, index in $scope.vidatios
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

        $scope.setCategory = (category) ->
            vidatio.log.info "CatalogCtrl setCategory called"
            vidatio.log.debug
                category: category
            $scope.filter.category = category

            $scope.setStateParams()

        $scope.$watch "filter.dates.from", ->
            $scope.setStateParams()

        $scope.$watch "filter.dates.to", ->
            $scope.setStateParams()

        $scope.setStateParams = ->
            stateParams = {}

            if $scope.filter.dates.from
                from = $scope.filter.dates.from.format("DD-MM-YYYY")
            else
                from = ""

            if $scope.filter.dates.to
                to = $scope.filter.dates.to.format("DD-MM-YYYY")
            else
                to = ""

            stateParams.myvidatios = if $scope.filter.showMyVidatios then $scope.filter.showMyVidatios else ""
            stateParams.category = if $scope.filter.category then $scope.filter.category else ""
            stateParams.tags = if $scope.filter.tags then $scope.filter.tags.join("|") else ""
            stateParams.from = from
            stateParams.to = to

            $state.go $state.current, stateParams,
                notify: false
                reload: $state.current
]
