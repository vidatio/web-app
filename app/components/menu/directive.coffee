"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    "$timeout"
    "UserService"
    "$rootScope"
    "$log"
    "$state"
    ($timeout, UserService, $rootScope, $log, $state) ->

        restrict: "E"
        templateUrl: "components/menu/menu.html"
        replace: true
        link: ($scope, $element) ->

            # @method logout
            # @describe logout the user and route the user to another site
            $scope.logout = ->
                $log.info "Menu directive logout called"

                UserService.logout()

                # TODO for multiple use move this maybe to a helper function
                unless $rootScope.history.length
                    $log.info "UserCtrl redirect to app.index"
                    $state.go "app.index"
                    return

                for element in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - 1]

                    if element.name is "app.profile" or $state.$current.name is "app.profile"
                        $log.info "UserCtrl redirect to app.index"
                        $state.go "app.index"
                        break

            # Menu can have 3 different layouts so init in on every state change
            $scope.$on "$stateChangeSuccess", ->
                $timeout ->
                    $("#menu").jPushMenu()

            $scope.toggleMenu = ->
                $('#menu,body,.cbp-spmenu').removeClass "disabled active cbp-spmenu-open cbp-spmenu-push-toleft cbp-spmenu-push-toright menu-active"
                return true
]
