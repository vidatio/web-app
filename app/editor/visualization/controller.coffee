"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    "$scope"
    "TableService"
    "MapService"
    "$timeout"
    "DataService"
    "ProgressService"
    "ngToast"
    "$log"
    "ConverterService"
    "$translate"
    "VisualizationService"
    ($scope, Table, Map, $timeout, Data, Progress, ngToast, $log, Converter, $translate, Visualization) ->
        $scope.data = Data
        $scope.header = Table.header
        $scope.visualization = Visualization.options
        Visualization.options.fileType = Data.metaData.fileType

        # allows the user to trigger the recommender and redraw the diagram accordingly
        # @method recommend
        $scope.recommend = ->
            Visualization.useRecommendedOptions()
            Visualization.create()
            Table.updateAxisSelection(Number($scope.visualization.xColumn) + 1, Number($scope.visualization.yColumn) + 1)
            return true

        $timeout ->
            # After having recommend diagram options, we watch the dataset of the table
            # because the watcher fires at initialization the diagram gets immediately drawn
            # FIXME: What should happen, if a person clears the table after watching shp?!
            Visualization.create()
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

        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "VisualizationCtrl shareVisualization called"
            $log.debug
                type: type

            fileName = $scope.data.name + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            Visualization.downloadAsImage fileName, type

]
