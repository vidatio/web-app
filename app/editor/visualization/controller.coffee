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
        dataset = Table.getDataset()
        trimmedDataset = vidatio.helper.trimDataset(dataset)
        cuttedDataset = vidatio.helper.cutDataset(trimmedDataset)

        switch Data.meta.fileType
            when "shp"
                $scope.recommendedDiagram = "map"
                Map.setScope $scope
            else
                { recommendedDiagram, xColumn, yColumn } = vidatio.recommender.run cuttedDataset, dataset
                $scope.recommendedDiagram = recommendedDiagram
                chartData = [trimmedDataset.map((value, index) -> value[xColumn]),
                    trimmedDataset.map((value, index) -> value[yColumn])]

                $log.info "Recommender chose type: #{recommendedDiagram} with column #{xColumn} and #{yColumn}"
                switch recommendedDiagram
                    when "scatter"
                        # Currently default labels for the points are used
                        chartData[0].unshift "A_x"
                        chartData[1].unshift "A"
                        new vidatio.ScatterPlot chartData
                    when "map"
                        Map.setScope $scope
                        geoJSON = Converter.convertArrays2GeoJSON chartData
                        Map.setGeoJSON geoJSON
                    when "parallel"
                        # Parallel coordinate chart need the columns as rows so we transpose
                        chartData = vidatio.helper.transposeDataset chartData
                        new vidatio.ParallelCoordinates chartData
                    when "bar"
                        # Bar chart need the columns as rows so we transpose
                        chartData = vidatio.helper.transposeDataset chartData
                        new vidatio.BarChart chartData
                    when "line"
                        # Currently default labels for the bars are used
                        chartData[0].unshift "x"
                        chartData[1].unshift "A"
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
