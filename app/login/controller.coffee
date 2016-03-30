"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    "UserService"
    "$rootScope"
    "$log"
    "$translate"
    "ngToast"
    ($scope, UserService, $rootScope, $log, $translate, ngToast) ->
        $scope.logon = ->
            $log.info "LoginCtrl logon called"

            UserService.logon($scope.user).then(
                (value) ->
                    $log.info "LoginCtrl successfully logged in"
                    $log.debug
                        value: value

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
