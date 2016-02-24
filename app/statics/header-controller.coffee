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
    ($scope, $rootScope, $timeout, Map, Data, $log, ngToast, $translate) ->

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
            geoJSON = Map.getGeoJSON()
            Data.saveViaAPI geoJSON

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
