"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    "$timeout"
    "UserService"
    "$rootScope"
    "$state"
    ($timeout, UserService, $rootScope, $state) ->
        restrict: "E"
        templateUrl: "components/menu/menu.html"
        replace: true
        link: ($scope, $element) ->

            # @method logout
            # @describe call UserService.logout() to logout the current user
            $scope.logout = ->
                UserService.logout()

            # Menu can have 3 different layouts so init it on every state change
            $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
                $timeout ->
                    $("#menu").jPushMenu()

            $scope.toggleMenu = ->
                $('#menu,body,.cbp-spmenu').removeClass "disabled active cbp-spmenu-open cbp-spmenu-push-toleft cbp-spmenu-push-toright menu-active"
                return true
]
