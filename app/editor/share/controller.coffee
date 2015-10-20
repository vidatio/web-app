# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "ShareService"
    ($scope, Share) ->
        $scope.shareVisualization = (type) ->
            $map = $("#map")

            # Check Share.mapToImg for quality reduction if needed
            promise = Share.mapToImg $map

            promise.then (obj) ->
                Share.download "obj_" + type, obj[type]


]
