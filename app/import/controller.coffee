# Import Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ImportCtrl", [
    "$scope"
    "$http"
    "$location"
    "$rootScope"
    "ImportService"
    "TableService"
    "ConverterService"
    "MapService"
    "DataService"
    ($scope, $http, $location, $rootScope, Import, Table, Converter, Map, Data) ->
        $scope.link = "http://www.wolfsberg.at/fileadmin/user_upload/Downloads/Haushalt2015.csv"
        $scope.progress = Import.progress

        editorPath = "/" + $rootScope.locale + "/editor"

        $scope.continueToEmptyTable = ->
            Table.reset()
            $location.path editorPath

        # Read via link
        $scope.load = ->
            url = $scope.link
            $http.get($rootScope.apiBase + "/v0/import"
                params:
                    url: url
            ).success (data) ->
                Table.setDataset data
                $location.path editorPath

        # Read via Browsing and Drag-and-Drop
        $scope.getFile = ->
            # Can't use file.type because of chromes File API
            fileType = $scope.file.name.split "."
            fileType = fileType[fileType.length - 1]

            if(fileType != "csv" && fileType != "zip")
                console.log "File format '" + fileType + "' is not supported."
                return

            Import.readFile($scope.file, fileType).then (fileContent) ->
                switch fileType
                    when "csv"
                        dataset = Converter.convertCSV2Arrays(fileContent)
                        geoJSON = Converter.convertArrays2GeoJSON(dataset)
                        Data.setGeoJSON(geoJSON)
                        Table.setDataset(dataset)
                        Map.setGeoJSON(geoJSON)
                    when "zip"
                        Converter.convertSHP2GeoJSON(fileContent).then (geoJSON) ->
                            dataset = Converter.convertGeoJSON2Arrays(geoJSON)
                            Data.setGeoJSON(geoJSON)
                            colHeaders = Converter.convertGeoJSON2ColHeaders(geoJSON)

                            Table.setDataset(dataset)
                            Table.setColHeaders(colHeaders)

                            console.log Table.colHeaders
                            Map.setGeoJSON(geoJSON)

                $location.path editorPath
            , (error) ->
                console.log error
]
