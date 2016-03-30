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
    "$window"
    "$stateParams"
    ($scope, Table, Map, $timeout, Data, Progress, ngToast, $log, Converter, $translate, Visualization, $window, $stateParams) ->
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
            # FIXME: Whats should happen, if a person clears the table after watching shp?!
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

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "VisualizationCtrl shareVisualization called"
            $log.debug
                type: type

            $translate("OVERLAY_MESSAGES.VISUALIZATION_PREPARED").then (translation) ->
                Progress.setMessage translation

            if Visualization.options.type is "map"
                $targetElem = $("#map")
            else if Visualization.options.type is "parallel"
                $targetElem = $("#chart svg")
            else
                $targetElem = $("#d3plus")

            vidatio.visualization.visualizationToBase64String($targetElem)
            .then (obj) ->
                $log.info "VisualizationCtrl visualizationToBase64String promise success called"
                $log.debug
                    obj: obj

                $timeout ->
                    Progress.setMessage ""

                fileName = $scope.data.name + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
                vidatio.visualization.download fileName, obj[type]

            .catch (error) ->
                $translate(error.i18n).then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

]
