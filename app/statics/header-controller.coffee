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

        $rootScope.savedWorks = true

        $scope.header = Data.meta

        console.log "test ",  $scope.header

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

            if Data.meta.fileType is "shp"
                dataset = Map.getGeoJSON()
            else
                dataset = Table.dataset.slice()
                if Table.useColumnHeadersFromDataset
                    dataset.unshift Table.instanceTable.getColHeader()

            Data.saveViaAPI dataset
]
