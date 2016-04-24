# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "TableService"
    "DataService"
    ($scope, Table, Data) ->
        $scope.header = Data

        menuActive = ->
            # set bool value editorNotInitialized; 'true' means editor was not initialized with a dataset yet
            # -> if 'true' edit- and share-page linking has to be disabled
            if Table.getDataset().length == 1
                $scope.header.editorNotInitialized = true
            else
                $scope.header.editorNotInitialized = false

        $scope.$watch ->
            Data.datasetID
            menuActive()
        , ->
            $scope.datasetID = Data.datasetID



]
