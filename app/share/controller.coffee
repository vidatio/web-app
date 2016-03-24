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
    "CatalogFactory"
    ($scope, $rootScope, $translate, Data, $log, Map, Table, $timeout, CatalogFactory) ->
        $scope.share = Data
        $scope.goToPreview = false

        $scope.vidatio =
            publish: true

        $translate("NEW_VIDATIO").then (translation) ->
            $scope.vidatio.name = "#{translation} #{moment().format("DD/MM/YYYY")}"

        CatalogFactory.getCategories().query (response) ->
            $log.info "ShareCtrl successfully queried categories"
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


        $scope.saveDataset = ->
            return $scope.goToPreview = !$scope.goToPreview
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

            Data.saveViaAPI dataset, $scope.vidatio
]
