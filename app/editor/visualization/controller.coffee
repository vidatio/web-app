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


                $log.info "Recommender chose type: #{recommendedDiagram} with column #{xColumn} and #{yColumn}"
                switch recommendedDiagram
                    when "scatter"
                        chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                        new vidatio.ScatterPlot chartData
                    when "map"
                        # TODO map dataset and merge parser & recommender
                        Map.setScope $scope
                        # Use the whole dataset because we want the other attributes inside the popups
                        geoJSON = Converter.convertArrays2GeoJSON trimmedDataset
                        Map.setGeoJSON geoJSON
                    when "parallel"
                        # Parallel coordinate chart needs the columns as rows and the values in x direction need to be first
                        transposedDataset = vidatio.helper.transposeDataset(trimmedDataset)
                        chartData = vidatio.helper.subsetWithXColumnFirst(transposedDataset, xColumn, yColumn)
                        chartData = vidatio.helper.transposeDataset(chartData)
                        new vidatio.ParallelCoordinates chartData
                    when "bar"
                        # Bar chart need the columns as rows so we transpose
                        chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                        new vidatio.BarChart chartData
                    when "timeseries"
                        # Currently default labels for the bars are used
                        chartData = vidatio.helper.transformToArrayOfObjects trimmedDataset, xColumn, yColumn, recommendedDiagram
                        new vidatio.TimeseriesChart chartData
                    else
                        # TODO: show a default image here
                        $log.error "EdtiorCtrl recommend diagram failed, dataset isn't usable with vidatio"

        Progress.setMessage ""

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
