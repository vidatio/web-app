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
    "VisualizationService"
    ($scope, $rootScope, $timeout, Map, Data, $log, ngToast, $translate, Table, Visualization) ->
        # The three bool values represent the three tabs in the header
        # @property activeViews
        # @type {Array}
        $rootScope.activeViews = [true, true]

        # Invert the value of the clicked tab to hide or show views in the editor
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 1 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $log.info "HeaderCtrl tabClicked called"
            $log.debug
                message: "HeaderCtrl tabClicked called"
                tabIndex: tabIndex

            $rootScope.activeViews[tabIndex] = !$rootScope.activeViews[tabIndex]
            Visualization.create()

        $scope.saveDataset = ->
            $log.info "HeaderCtrl saveDataset called"

            if Data.meta.fileType is "shp"
                dataset = Map.getGeoJSON()
            else
                dataset = Table.dataset.slice()
                if Table.useColumnHeadersFromDataset
                    dataset.unshift Table.instanceTable.getColHeader()

            Data.saveViaAPI dataset

        $scope.hideLink = ->
            $rootScope.showLink = false

        $scope.copyLink = ->
            $log.info "HeaderCtrl copyLink called"
            window.getSelection().removeAllRanges()
            link = document.querySelector "#link"
            range = document.createRange()
            range.selectNode link
            window.getSelection().addRange(range)

            try
                successful = document.execCommand "copy"

                $log.debug
                    message: "HeaderCtrl copyLink copy link to clipboard"
                    successful: successful

                $translate("TOAST_MESSAGES.LINK_COPIED")
                    .then (translation) ->
                        ngToast.create
                            content: translation
            catch err
                $log.info "Link could not be copied"
                $log.error
                    error: error

            window.getSelection().removeAllRanges()
]
