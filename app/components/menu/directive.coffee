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
                $log.info "Menu directive logout called"

                UserService.logout()

                # Default routing for user at logout success
                unless $rootScope.history.length
                    $log.info "UserCtrl redirect to app.index"
                    $state.go "app.index"
                    return

                for element in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - 1]

                    # Because the user may started at profile, after logout success we route the user to index
                    if element.name is "app.profile" or $state.$current.name is "app.profile"
                        $log.info "UserCtrl redirect to app.index"
                        $state.go "app.index"
                        break

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
