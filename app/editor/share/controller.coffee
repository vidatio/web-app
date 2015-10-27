# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "ShareService"
    "DataService"
    "HelperService"
    "ProgressOverlayService"
    "ngToast"
    ($scope, Share, Data, Helper, ProgressOverlay, ngToast) ->
        #@method $scope.shareVisualization
        #@description exports a
        #@params {string} type
        $scope.shareVisualization = (type) ->
            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                if Data.meta.fileName == ""
                    fileName = Helper.dateToString(new Date())
                else
                    fileName = Data.meta.fileName

                    Share.download fileName, obj[type]
            , (error) ->
                ngToast.create
                    content: error
                    className: "danger"

            , (notify) ->
                console.log "notify should appear"
                ProgressOverlay.setMessage notify
]

