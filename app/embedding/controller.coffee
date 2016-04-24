"use strict"

app = angular.module "app.controllers"

app.controller "EmbeddingCtrl", [
    "$scope"
    "DatasetFactory"
    "ProgressService"
    "$stateParams"
    "$translate"
    "DataService"
    "VisualizationService"
    "ErrorHandler"
    "$state"
    ($scope, DataFactory, Progress, $stateParams, $translate, Data, Visualization, ErrorHandler, $state) ->
        $scope.error = false

        $("header").hide()
        $("footer").hide()

        unless $stateParams.id
            Visualization.options.type = false
            $scope.error = true
            return

        DataFactory.get {id: $stateParams.id}, (data) ->
            $scope.data = data
            $scope.data.updated = new Date($scope.data.updatedAt)
            $scope.data.created = new Date($scope.data.createdAt)

            if $scope.data.metaData.tagIds?
                $scope.data.tags = []
                for tag in $scope.data.metaData.tagIds
                    $scope.data.tags.push tag.name

            $scope.data.category = $scope.data.metaData.categoryId.name
            $scope.data.userName = $scope.data.metaData.userId.name
            $scope.data.author = $scope.data.metaData.author
            $scope.data.title = $scope.data.metaData.name

            Data.useSavedData $scope.data

            options = $scope.data.visualizationOptions
            options.fileType = if $scope.data.metaData?.fileType? then $scope.data.metaData.fileType else "csv"

            Visualization.create(options)
        , (error) ->
            Visualization.options.type = false
            $scope.error = true
            ErrorHandler.format error
]
