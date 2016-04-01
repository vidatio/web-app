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
            # @describe logout and route the user to another site
            $scope.logout = ->
                UserService.logout()

                # Default routing for user at logout success
                unless $rootScope.history.length
                    $state.go "app.index"
                    return

                for element in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - 1]

                    # Because the user may started at profile, after logout success we route the user to index
                    if element.name is "app.profile" or $state.$current.name is "app.profile"
                        $state.go "app.index"
                        break

            # Menu can have 3 different layouts so init it on every state change
            $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
                $timeout ->
                    $("#menu").jPushMenu()

            $scope.toggleMenu = ->
                $('#menu,body,.cbp-spmenu').removeClass "disabled active cbp-spmenu-open cbp-spmenu-push-toleft cbp-spmenu-push-toright menu-active"
                return true
]
