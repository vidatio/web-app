# Visualization Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "VisualizationCtrl", [
    '$scope'
    'TableService'
    'MapService'
    "$timeout"
    "ShareService"
    "DataService"
    "ProgressService"
    "ngToast"
    "$log"
    "ConverterService"
    "$translate"
    "VisualizationService"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter, $translate, Visualization) ->
        $scope.visualization = Visualization.options
        $scope.meta = Data.meta
        $scope.header = Table.header

        # allows the user to trigger the recommender and redraw the diagram accordingly
        # @method recommend
        $scope.recommend = ->
            Visualization.recommendDiagram()
            Visualization.create
                type: $scope.visualization.diagramType
                xColumn: $scope.visualization.xAxisCurrent
                yColumn: $scope.visualization.yAxisCurrent
                color: $scope.visualization.color

        if Data.meta.fileType is "shp"
            $scope.visualization.diagramType = "map"
            Map.setInstance()
        else
            # After having recommend diagram options, we watch the dataset of the table
            # because the watcher fires at initialization the diagram gets immediately drawn
            # FIXME: Whats should happen, if a person clears the table after watching shp?!
            $scope.$watch (->
                Table.dataset
            ), ( ->
                $log.info "VisualizationCtrl dataset watcher triggered"

                Visualization.create
                    type: $scope.visualization.diagramType
                    xColumn: $scope.visualization.xAxisCurrent
                    yColumn: $scope.visualization.yAxisCurrent
                    color: $scope.visualization.color
            ), true

        $timeout ->
            Progress.setMessage ""

        $scope.$on "colorpicker-selected", ->
            Visualization.create
                type: $scope.visualization.diagramType
                xColumn: $scope.visualization.xAxisCurrent
                yColumn: $scope.visualization.yAxisCurrent
                color: $scope.visualization.color

        # @method changeAxisColumnSelection
        # @param {Number} axis
        # @param {Number} id
        $scope.setAxisColumnSelection = (axis, id) ->
            $log.info "VisualizationCtrl changeAxisColumnSelection called"
            $log.debug
                axis: axis
                id: id

            if axis is "x" and Visualization.isInputValid id, $scope.visualization.yAxisCurrent, $scope.diagramType
                $scope.visualization.xAxisCurrent = id
            else if axis is "y" and Visualization.isInputValid $scope.visualization.xAxisCurrent, id, $scope.diagramType
                $scope.visualization.yAxisCurrent = id
            else
                $translate($scope.visualization.translationKeys[$scope.visualization.diagramType]).then (diagramName) ->
                    return $translate 'TOAST_MESSAGES.COLUMN_NOT_POSSIBLE',
                        column: Table.getHeader()[id]
                        diagramType: diagramName
                .then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"
                return
            Table.setDiagramColumns $scope.visualization.xAxisCurrent, $scope.visualization.yAxisCurrent
            Visualization.create
                type: $scope.visualization.diagramType
                xColumn: $scope.visualization.xAxisCurrent
                yColumn: $scope.visualization.yAxisCurrent
                color: $scope.visualization.color

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (type) ->
            $log.info "VisualizationCtrl selectDiagram called"
            $log.debug
                type: type

            $translate($scope.visualization.translationKeys[type]).then (translation) ->
                $scope.visualization.selectedDiagramName = translation
                $scope.visualization.diagramType = type

                Visualization.create
                    type: $scope.visualization.diagramType
                    xColumn: $scope.visualization.xAxisCurrent
                    yColumn: $scope.visualization.yAxisCurrent
                    color: $scope.visualization.color

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "VisualizationCtrl shareVisualization called"
            $log.debug
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "VisualizationCtrl shareVisualization promise success called"
                $log.debug
                    obj: obj

                Progress.setMessage ""

                if Data.meta.fileName == ""
                    fileName = vidatio.helper.dateToString(new Date())
                else
                    fileName = Data.meta.fileName

                Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"
            , (notify) ->
                Progress.setMessage notify

        $scope.geojson =
            data: Map.geoJSON
            style: ->
                {}
            pointToLayer: (feature, latLng) ->
                new L.marker(latLng, icon: L.icon(
                    iconUrl: '../images/marker-small.png'
                    iconSize: [25, 30]
                    iconAnchor: [12.5, 30]
                    popupAnchor: [0, -30]
                ))
            onEachFeature: (feature, layer) ->
                # So every markers gets a popup
                html = ""
                isFirstAttribute = true

                for property, value of feature.properties

                    if value
                        if isFirstAttribute
                            html += "<b>"

                        if vidatio.helper.isEmailAddress(value)
                            html += "<a href='mailto:" + value + "' target='_blank'>" + value + "</a><br>"
                        else if vidatio.helper.isPhoneNumber(value)
                            html += "<a href='tel:" + value + "' target='_blank'>" + value + "</a><br>"
                        else if vidatio.helper.isURL(value)
                            html += "<a href='" + value + "' target='_blank'>" + value + "</a><br>"
                        else if value
                            html += value + "<br>"

                        if isFirstAttribute
                            html += "</b>"
                            isFirstAttribute = false

                unless html
                    html = "Keine Informationen vorhanden"

                layer.bindPopup(html)
]
