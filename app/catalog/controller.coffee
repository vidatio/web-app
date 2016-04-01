"use strict"

app = angular.module "app.controllers"

app.controller "CatalogCtrl", [
    "$scope"
    "$timeout"
    "ProgressService"
    "DataService"
    "$translate"
    "ngToast"
    "$stateParams"
    "$state"
    "DatasetsFactory"
    "CategoriesFactory"
    "TagsService"
    "$log"
    ($scope, $timeout, Progress, Data, $translate, ngToast, $stateParams, $state, Datasets, Categories, Tags, $log) ->
        angular.element('#my-vidatio-checkbox').radiocheck()

        # @description Filter vidatios according to the GET parameters of the $stateParams
        $scope.filter =
            dates:
                from: if $stateParams.from then moment($stateParams.from, "DD-MM-YYYY") else ""
                to: if $stateParams.to then moment($stateParams.to, "DD-MM-YYYY") else ""
            category: if $stateParams.category then $stateParams.category else ""
            tags: if $stateParams.tags then $stateParams.tags.split("|") else ""
            showMyVidatios: if $stateParams.myvidatios then if $stateParams.myvidatios is "true" then true else false

        stateParams = {}
        $scope.maxDate = moment.tz('UTC').hour(12).startOf('h')

        $scope.tags = Tags.getAndPreprocessTags()

        Categories.query (response) ->
            $log.info "CatalogCtrl successfully queried categories"
            $scope.categories = response

        Datasets.query (response) ->
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

        # the values of the datepicker need to be watched, because the ng-change directive never executes a function
        $scope.$watch "filter.dates.from", ->
            $scope.setStateParams()

        $scope.$watch "filter.dates.to", ->
            $scope.setStateParams()

        # @method setCategory
        # @description Set new category and update URL by setting new stateParams
        # @param {String} category
        $scope.setCategory = (category) ->
            vidatio.log.info "CatalogCtrl setCategory called"
            vidatio.log.debug
                category: category
            $scope.filter.category = category

            $scope.setStateParams()

        # @method setStateParams
        # @description Determine which filters are active and send user to the same state with new $stateParams
        $scope.setStateParams = ->
            stateParams.myvidatios = if $scope.filter.showMyVidatios then $scope.filter.showMyVidatios else ""
            stateParams.category = if $scope.filter.category then $scope.filter.category else ""
            stateParams.tags = if $scope.filter.tags then $scope.filter.tags.join("|") else ""
            stateParams.from = if $scope.filter.dates.from then $scope.filter.dates.from.format("DD-MM-YYYY") else ""
            stateParams.to = if $scope.filter.dates.to then $scope.filter.dates.to.format("DD-MM-YYYY") else ""

            $scope.changeURL()

        # @method reset
        # @description Iterate over all filters in the filter object (and subsequent objects) and reset them
        #               by using an empty String
        $scope.reset = ->
            for attr of $scope.filter
                if $scope.filter[attr]?.constructor is Object
                    for childAttr of $scope.filter[attr]
                        $scope.filter[attr][childAttr] = ""
                else
                    $scope.filter[attr] = ""

            for attr of stateParams
                stateParams[attr] = ""

            $scope.changeURL()

        $scope.changeURL = ->
            $state.go $state.current, stateParams,
                notify: false
                reload: $state.current

        # @method $scope.openInEditor
        # @description set the vidatio options from saved dataset
        $scope.openInEditor = (data) ->
            $translate("OVERLAY_MESSAGES.PARSING_DATA").then (message) ->
                Progress.setMessage message
                Data.useSavedData data
]
