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

        # set bool value editorNotInitialized; 'true' means editor was not initialized with a dataset yet
        # -> if 'true' edit- and share-page linking has to be disabled
        if Table.getDataset().length == 1
            $scope.header.editorNotInitialized = true
        else
            $scope.header.editorNotInitialized = false

        # @method saveDataset
        # @description checks if the current dataset has filetype 'shp' or 'csv' and prepares the dataset for saving according to fileType
        $scope.saveDataset = ->
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
