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
            if Data.meta.fileType is "shp"
                dataset = Map.getGeoJSON()
            else
                dataset = Table.dataset

            Data.saveViaAPI dataset

        $scope.hideLink = ->
            $rootScope.showLink = false

        $scope.copyLink = ->
            $log.info "HeaderCtrl copyLink called"
            window.getSelection().removeAllRanges()
            link = document.querySelector '#link'
            range = document.createRange()
            range.selectNode link
            window.getSelection().addRange(range)

            try
                successful = document.execCommand 'copy'

                $log.debug
                    message: "HeaderCtrl copyLink copy link to clipboard"
                    successful: successful

                $translate('TOAST_MESSAGES.LINK_COPIED')
                    .then (translation) ->
                        ngToast.create
                            content: translation
            catch err
                $log.info "Link could not be copied"
                $log.error
                    error: error

            window.getSelection().removeAllRanges()
]
