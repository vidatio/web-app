"use strict"

app = angular.module "app.directives"

app.directive "menu", [
    "$timeout"
    "$log"
    ($timeout, $log) ->
        restrict: "E"
        templateUrl: "menu/menu.html"
        replace: true
        link: ($scope, $element) ->

            # Menu can have 3 different layouts so init it on every state change
            $scope.$on "$stateChangeSuccess", (event, toState, toParams, fromState, fromParams) ->
                $log.info "MenuDirective Site state changed"
                $log.debug
                    message: "MenuDirective Site state changed"
                    event: event
                    toState: toState
                    toParams: toParams
                    fromState: fromState
                    fromParams: fromParams

                $timeout ->
                    $("#menu").jPushMenu()

                    $log.info "MenuDirective Menu initialized"


            $scope.toggleMenu = ->
                $log.info "MenuDirective toogleMenu called"

                $('#menu,body,.cbp-spmenu').removeClass "disabled active cbp-spmenu-open cbp-spmenu-push-toleft cbp-spmenu-push-toright menu-active"
                return true
]
