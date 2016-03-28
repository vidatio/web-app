"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    "$scope"
    "TableService"
    "MapService"
    "$timeout"
    "ShareService"
    "DataService"
    "ProgressService"
    "ngToast"
    "$log"
    "ConverterService"
    "$translate"
    "VisualizationService"
    "$stateParams"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter, $translate, Visualization, $stateParams) ->
        $scope.data = Data
        $scope.header = Table.header
        $scope.visualization = Visualization.options
        Visualization.options.fileType = Data.meta.fileType

        # allows the user to trigger the recommender and redraw the diagram accordingly
        # @method recommend
        $scope.recommend = ->
            Visualization.useRecommendedOptions()
            Visualization.create()

        unless $stateParams.id
            if Data.meta.fileType is "shp"
                $scope.visualization.type = "map"
                Map.setInstance()
            else
                # After having recommend diagram options, we watch the dataset of the table
                # because the watcher fires at initialization the diagram gets immediately drawn
                # FIXME: Whats should happen, if a person clears the table after watching shp?!
                $scope.$watch (->
                    Table.dataset
                ), ( ->
                    Visualization.create()
                ), true

            $timeout ->
                Progress.setMessage ""

        $scope.$on "colorpicker-selected", ->
            $timeout ->
                Visualization.create()

        # @method changeAxisColumnSelection
        # @param {Number} axis
        # @param {Number} id
        $scope.setAxisColumnSelection = (axis, id) ->
            if axis is "x"
                $scope.visualization.xColumn = id
            else if axis is "y"
                $scope.visualization.yColumn = id

            Visualization.create()

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (type) ->
            $translate($scope.visualization.translationKeys[type]).then (translation) ->
                $scope.visualization.selectedDiagramName = translation
                $scope.visualization.type = type

                Visualization.create()

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $timeout ->
                    Progress.setMessage ""

                fileName = $scope.data.name + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")

                Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"
            , (notify) ->
                Progress.setMessage notify
]
