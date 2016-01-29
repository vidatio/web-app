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
    ($scope, Table, Map, $timeout, Share, Data, Progress, ngToast, $log, Converter) ->

        Table.resetColHeaders()
        #Table.setDataset [[200, 500], [300, 600], [400, 700]] #Line
        Table.setDataset [[200, "Apfel"], [300, "Banane"], [400, "Orange"]] #Bar

        dataset = Table.getDataset()

        subDataset = vidatio.helper.trimDataset(dataset)
        subDataset = vidatio.helper.cutDataset(subDataset)

        switch Data.meta.fileType
            when "shp"
                $scope.recommendedDiagram = "map"
                new Map($scope)

            else
                { recommendedDiagram, xColumn, yColumn } = vidatio.recommender.run subDataset

                # DEBUG
                recommendedDiagram = "bar"
                # /DEBUG

                console.log xColumn, yColumn

                $scope.recommendedDiagram = recommendedDiagram
                chartData = [dataset.map((value, index) -> value[xColumn]), dataset.map((value, index) -> value[yColumn])]

                $log.info "Recommender chose type: #{recommendedDiagram} with column #{xColumn} and #{yColumn}"
                switch recommendedDiagram
                    when "scatter"
                        new vidatio.ScatterPlot chartData
                    when "map"
                        map = new Map($scope)
                        geoJSON = Converter.convertArrays2GeoJSON dataset
                        map.setGeoJSON geoJSON
                    when "parallel"
                        new vidatio.ParallelCoordinates chartData
                    when "bar"
                        chartData = vidatio.helper.transposeDataset chartData
                        new vidatio.BarChart chartData
                    when "line"
                        # Column-Headers as the first element in the columns - TODO
                        chartData[0].unshift "A"
                        chartData[1].unshift "B"

                        new vidatio.LineChart chartData
                    else
                        # TODO: show a default image here
                        $log.error "EdtiorCtrl recommend diagram failed, dataset isn't usable with vidatio"

        #TODO: Extend sharing visualization for other diagrams
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $log.info "ShareCtrl shareVisualization called"
            $log.debug
                message: "ShareCtrl shareVisualization called"
                type: type

            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                $log.info "ShareCtrl shareVisualization promise success called"
                $log.debug
                    message: "Share mapToImg success callback"
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
]
