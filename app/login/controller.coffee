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
            $log.info "LoginCtrl logon called"

            UserService.logon($scope.user).then(
                (value) ->
                    $log.info "LoginCtrl successfully logged in"
                    $log.debug
                        value: value

                    # Default routing for user at logout success
                    unless $rootScope.history.length
                        $log.info "LoginCtrl redirect to app.index"
                        $state.go "app.index"
                        return

                    # After login success we want to route the user to the last page except login and registration
                    for element in $rootScope.history
                        element = $rootScope.history[$rootScope.history.length - 1]
                        if element.name isnt "app.login" and element.name isnt "app.registration" and element.name isnt ""
                            $log.info "LoginCtrl redirect to " + element.name
                            $state.go element.name, element.params.locale
                            return

                    $state.go "app.index"

                (error) ->
                    $log.info "LoginCtrl error on login"

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
