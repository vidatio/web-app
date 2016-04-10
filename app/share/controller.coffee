# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "$rootScope"
    "$translate"
    "DataService"
    "$log"
    "MapService"
    "TableService"
    "$timeout"
    "CategoriesFactory"
    "VisualizationService"
    "$stateParams"
    "ProgressService"
    "ngToast"
    "ErrorHandler"
    "$state"
    ($scope, $rootScope, $translate, Data, $log, Map, Table, $timeout, Categories, Visualization, $stateParams, Progress, ngToast, ErrorHandler, $state) ->
        $scope.goToPreview = false
        $scope.hasData = Table.dataset.length && Table.dataset[0].length
        $scope.visualization = Visualization.options

        $scope.vidatio = Data.vidatio
        $scope.vidatio.publish = true

        $translate("NEW_VIDATIO").then (translation) ->
            $scope.vidatio.name = Data.name || "#{translation} #{moment().format("DD/MM/YYYY")}"

        Categories.query (response) ->
            $scope.categories = response

        $timeout ->
            # initialize tagsinput on page-init for propper displaying the tagsinput-field
            $(".tagsinput").tagsinput()

            #to remove tags label on focus & remove flag-ui tags-input length
            $(".tagsinput-primary ").on "focus", ".bootstrap-tagsinput input", ->
                $("span.placeholder").hide()
                $(this).attr("style", "width:auto")

            #to change color after user selection (impossible with css)
            $(".selection select").change -> $(this).addClass "selected"

            #plus-button for tags-input
            $(".add-tag").click -> $(".bootstrap-tagsinput input").focus()

            #flat-ui checkbox
            $("#publish").radiocheck()

        # copied from login controller, redundant?
        # To give the prepends tags of flat ui the correct focus style
        $(".input-group").on("focus", ".form-control", ->
            $(this).closest(".input-group, .form-group").addClass "focus"
        ).on "blur", ".form-control", ->
            $(this).closest(".input-group, .form-group").removeClass "focus"

        $timeout ->
            Visualization.create()

        $scope.saveDataset = ->
            $translate("OVERLAY_MESSAGES.SAVE_DATASET").then (translation) ->
                Progress.setMessage translation

            if Visualization.options.type is "map"
                $targetElem = $("#map")
            else if Visualization.options.type is "parallel"
                $targetElem = $("#chart svg")
            else
                $targetElem = $("#d3plus")

            vidatio.visualization.visualizationToBase64String($targetElem)
            .then (obj) ->
                switch Data.metaData.fileType
                    when "csv"
                        dataset = Table.dataset.slice()
                        if Table.useColumnHeadersFromDataset
                            dataset.unshift Table.instanceTable.getColHeader()
                    when "shp"
                        dataset = Map.getGeoJSON()

                $scope.vidatio.tags = $(".tag").map ->
                    return $(@).text()
                .get()

                Data.saveViaAPI dataset, $scope.vidatio, obj["png"], (errors, response) ->
                    Progress.setMessage ""

                    if errors?
                        ErrorHandler.format errors
                        return false

                    $scope.vidatio._id = response._id

                    $scope.link = $state.href("app.dataset", {id: response._id}, {absolute: true})

                    $translate('TOAST_MESSAGES.DATASET_SAVED')
                    .then (translation) ->
                        ngToast.create
                            content: translation

                    return $scope.goToPreview = !$scope.goToPreview

            .catch (error) ->
                $translate(error.i18n).then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"


        $scope.downloadVisualization = (type) ->
            fileName = $scope.vidatio.name + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            Visualization.downloadAsImage fileName, type

        $scope.downloadCSV = ->
            Data.downloadCSV($scope.vidatio.name)

        # @method $scope.copyVidatioLink
        # @description copy link to dataset to clipboard
        $scope.copyVidatioLink = ->
            Data.copyVidatioLink("#vidatio-link")
]
