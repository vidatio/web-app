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
            $scope.logout = ->
                UserService.logout()
                console.log "1"
                # TODO refactor
                unless $rootScope.history.length
                    console.log "2"
                    $log.info "UserCtrl redirect to app.index"

                    # TODO current locale instead of preferredLanguage
                    $state.go "app.index"
                    return

                # TODO refactor
                for element in $rootScope.history
                    console.log "3"
                    element = $rootScope.history[$rootScope.history.length - 1]

                    if element.name is "app.profile" or $state.$current.name is "app.profile"
                        console.log "4"
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
