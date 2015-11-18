"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    "UserService"
    "$rootScope"
    "$state"
    "$log"
    "$translate"
    "ngToast"
    ($scope, UserService, $rootScope, $state, $log, $translate, ngToast) ->
        $scope.logon = ->
            $log.info "UserCtrl logon called"

            UserService.logon($scope.user.name, $scope.user.password).then(
                (value) ->
                    $log.info "UserCtrl successfully logged in"
                    $log.debug
                        value: value

                    # TODO for multiple use move this maybe to a helper function
                    unless $rootScope.history.length
                        $log.info "UserCtrl redirect to app.index"
                        $state.go "app.index"
                        return

                    # TODO for multiple use move this maybe to a helper function
                    for element in $rootScope.history
                        element = $rootScope.history[$rootScope.history.length - 1]
                        if element.name isnt "app.login" and element.name isnt "app.registration" and element.name isnt ""
                            $log.info "UserCtrl redirect to " + element.name
                            $state.go element.name, element.params.locale
                            return

                    $state.go "app.index"

                (error) ->
                    $log.info "UserCtrl error on login"

                    $translate('TOAST_MESSAGES.NOT_AUTHORIZED').then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
            )

        # To give the prepends tags of flat ui the correct focus style
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
