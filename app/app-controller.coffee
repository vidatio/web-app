# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    "$rootScope"
    "$state"
    "$stateParams"
    "$translate"
    "$log"
    ($scope, $rootScope, $state, $stateParams, $translate, $log) ->

        $scope.logout = ->
            UserService.logout()
            $state.go "home"

        # save locale in rootScope to build links with correct language
        if $rootScope.locale != $stateParams.locale
            $rootScope.locale = $stateParams.locale
            #$translate.use $stateParams.locale

        # switch language at runtime
        $scope.changeLanguage = (langKey) ->
            $translate.use langKey

        # Closing the menu on click of body should remove the active class
        $scope.disableMenuActive = ->
            $log.info "AppCtrl disableMenuActive called"

            $('#menu').removeClass "menu-active"
            return true
]
