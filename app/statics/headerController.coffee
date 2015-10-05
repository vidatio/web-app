# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "MapService"
    ($scope, $rootScope, $timeout, Map) ->
        # The three bool values represent the three tabs in the header
        # @property activeViews
        # @type {Array}
        $rootScope.activeViews = [true, true, false]

        # Invert the value of the clicked tab to hide or show views in the editor
        # @method tabClicked
        # @param {Number} tabIndex Number from 0 - 2 which represent the clicked tab
        $scope.tabClicked = (tabIndex) ->
            $rootScope.activeViews[tabIndex] = !$rootScope.activeViews[tabIndex]

            # REFACTOR Needed to wait for leaflet directive to render
            $timeout ->
                Map.resizeMap()


]
