app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    ($scope, $rootScope) ->
        $rootScope.activeViews = [true, true, false]
        $scope.tabClicked = (tabIndex) ->
            $rootScope.activeViews[tabIndex] = !$rootScope.activeViews[tabIndex]

]
