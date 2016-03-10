# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "MapService"
    "DataService"
    "$log"
    "ngToast"
    "$translate"
    "TableService"
    ($scope, $rootScope, $timeout, Map, Data, $log, ngToast, $translate, Table) ->

        $scope.header = Data
        $translate("NEW_VIDATIO").then (translation) ->
            $scope.standardTitle = translation

        # set bool value editorNotYetInitialized; it depends on wheter editor was already initialized with a dataset
        if Table.getDataset().length == 1
            $scope.header.editorNotInitialized = true
        else
            $scope.header.editorNotInitialized = false

        # REFACTOR Needed to wait for leaflet directive to render
        # $timeout ->
        #     # TODO: Only resize what is currently visible or used
        #     switch vidatio.Recommender.recommendedDiagram
        #         when "scatter"
        #             new ScatterPlot.getChart().resize()
        #         when "bar"
        #             new BarChart.getChart().resize()
        #         when "map"
        #             Map.resizeMap()
        #         else
        #             # TODO: show a default image here
        #             console.log "****************"
        #             console.log "nothing to recommend, abort! "

        $scope.saveDataset = ->
            $log.info "HeaderCtrl saveDataset called"

            if $scope.header.name is $scope.standardTitle
                $scope.header.name = $scope.header.name + " " + moment().format("HH_mm_ss")

            if Data.meta.fileType is "shp"
                dataset = Map.getGeoJSON()
            else
                dataset = Table.dataset.slice()
                if Table.useColumnHeadersFromDataset
                    dataset.unshift Table.instanceTable.getColHeader()

            Data.saveViaAPI dataset
]
