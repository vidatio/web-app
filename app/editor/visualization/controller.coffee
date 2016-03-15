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
    "$window"
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter, $translate, Visualization, $window) ->
        $scope.visualization = Visualization.options
        $scope.data = Data
        $scope.header = Table.header

        # using setTimeout to use only to the last resize action of the user
        id = null
        angular.element($window).bind 'resize', ->
            clearTimeout id
            id = setTimeout ->
                Visualization.create()
            , 500

        # allows the user to trigger the recommender and redraw the diagram accordingly
        # @method recommend
        $scope.recommend = ->
            header = if Table.useColumnHeadersFromDataset then Table.getHeader() else []
            Visualization.recommendDiagram header
            Visualization.create()

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
                $log.info "VisualizationCtrl dataset watcher triggered"

                Visualization.create()
            ), true

        $timeout ->
            Progress.setMessage ""

        $scope.$on "colorpicker-selected", ->
            $log.info "VisualizationCtrl colorpicker-selected emitted"
            $log.debug
                color: $scope.visualization.color

            $timeout ->
                Visualization.create()

        # @method changeAxisColumnSelection
        # @param {Number} axis
        # @param {Number} id
        $scope.setAxisColumnSelection = (axis, id) ->
            $log.info "VisualizationCtrl changeAxisColumnSelection called"
            $log.debug
                axis: axis
                id: id

            if axis is "x"
                $scope.visualization.xColumn = id
            else if axis is "y"
                $scope.visualization.xColumn = id

            Table.setDiagramColumns $scope.visualization.xColumn, $scope.visualization.yColumn

            if Visualization.isInputValid $scope.visualization.xColumn, $scope.visualization.yColumn, $scope.visualization.type
                Visualization.create()
            else
                $translate($scope.visualization.translationKeys[$scope.visualization.type]).then (diagramName) ->
                    return $translate 'TOAST_MESSAGES.COLUMN_NOT_POSSIBLE',
                        column: Table.getHeader()[id]
                        type: diagramName
                .then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"
                return true

        # @method selectDiagram
        # @param {String} name
        # @param {String} type
        $scope.selectDiagram = (type) ->
            $log.info "VisualizationCtrl selectDiagram called"
            $log.debug
                type: type

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

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "VisualizationCtrl shareVisualization promise success called"
                $log.debug
                    obj: obj

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
