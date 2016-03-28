"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "CatalogFactory"
    "$log"
    "DataFactory"
    "$timeout"
    "ProgressService"
    "DataService"
    "TableService"
    "$translate"
    "ngToast"
    "$stateParams"
    "$state"
    ($scope, CatalogFactory, $log, DataFactory, $timeout, Progress, Data, Table, $translate, ngToast, $stateParams, $state) ->
        $scope.filter =
            dates:
                from: undefined
                to: undefined
            category: ""
            showMyVidatios: if $stateParams?.myvidatios? then if $stateParams.myvidatios is "true" then true else false
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

        # @method $scope.openInEditor
        # @description set the vidatio options from saved dataset
        $scope.openInEditor = (data) ->
            $log.info "DatasetCtrl $scope.useSavedData called"

            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData data
]
