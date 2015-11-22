# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "MapService"
    "DataService"
    ($scope, $rootScope, $timeout, Map, Data) ->
        # The two bool values represent the two tabs in the header
        # @property activeViews
        # @type {Array}
        $rootScope.activeViews = [true, true]

        # Invert the value of the clicked tab to hide or show views in the editor
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 1 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $rootScope.activeViews[tabIndex] = !$rootScope.activeViews[tabIndex]

            # REFACTOR Needed to wait for leaflet directive to render
            $timeout ->
                Map.resizeMap()

        $scope.saveDataset = ->
            geoJSON = Map.getGeoJSON()
            Data.saveViaAPI(geoJSON)

        $scope.hideLink = ->
            $rootScope.showLink = false
]
