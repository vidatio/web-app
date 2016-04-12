"use strict"

app = angular.module "app.controllers"

app.controller "IframeCtrl", [
    "$scope"
    "DatasetFactory"
    "ProgressService"
    "$stateParams"
    "$translate"
    "DataService"
    "VisualizationService"
    "ErrorHandler"
    ($scope, DataFactory, Progress, $stateParams, $translate, Data, Visualization, ErrorHandler) ->
        $("header").hide()
        $("footer").hide()

        DataFactory.get {id: $stateParams.id}, (data) ->
            $scope.data = data
            $scope.data.updated = new Date($scope.data.updatedAt)
            $scope.data.created = new Date($scope.data.createdAt)

            if $scope.data.metaData.tagIds?
                $scope.data.tags = []
                for tag in $scope.data.metaData.tagIds
                    $scope.data.tags.push tag.name

            $scope.data.category = if $scope.data.metaData.categoryId?.name? then $scope.data.metaData.categoryId.name else "-"
            $scope.data.userName = if $scope.data.metaData.userId?.name? then $scope.data.metaData.userId.name else "-"
            $scope.data.author = if $scope.data.metaData.author? then $scope.data.metaData.author else "-"
            $scope.data.title = $scope.data.metaData.name || "Vidatio"

            Data.useSavedData $scope.data

            options = $scope.data.visualizationOptions
            options.fileType = if $scope.data.metaData?.fileType? then $scope.data.metaData.fileType else "csv"

            Visualization.create(options)
        , (error) ->
            ErrorHandler.format error
]

