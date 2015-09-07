# Animals - App Controller
# ========================

"use strict"

app = angular.module "app.controllers"

app.controller "AppCtrl", [
    "$scope"
    "$rootScope"
    "ProgressService"
    "UserService"
    "$state"
    "$stateParams"
    "$translate"
    ($scope, $rootScope, ProgressService, UserService, $state, $stateParams, $translate) ->
        $scope.progressService = ProgressService
        $scope.userService = UserService

        $scope.logout = ->
            UserService.logout()
            $state.go "home"

        # save locale in rootScope to build links with correct language
        if $rootScope.locale != $stateParams.locale
            $rootScope.locale = $stateParams.locale
        $translate.use $stateParams.locale

        # switch language at runtime
        $scope.changeLanguage = (langKey) ->
            $translate.use langKey


]
