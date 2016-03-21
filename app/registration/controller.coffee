"use strict"

app = angular.module("app.controllers")

app.controller "RegistrationCtrl", [
    "$rootScope"
    "$scope"
    "UserFactory"
    "$log"
    "$translate"
    "ngToast"
    "UserService"
    ($rootScope, $scope, UserFactory, $log, $translate, ngToast, UserService) ->
        $log.info "RegistrationCtrl called"

        $scope.register = ->
            $log.info "RegistrationCtrl register called"

            UserFactory.save $scope.user, (response) ->
                $log.info "RegistrationCtrl register success called"
                $log.debug
                    response: response

                $translate('TOAST_MESSAGES.REGISTRATION_SUCCESS').then (translation) ->
                    ngToast.create
                        content: translation

                logonAfterSuccessfulRegistration()

            , (error) ->
                $log.error "RegistrationCtrl register error called"
                $log.debug
                    error: error

                $translate('TOAST_MESSAGES.SERVER_ERROR').then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        logonAfterSuccessfulRegistration = ->
            $log.info "RegistrationCtrl logon called"

            console.log $scope.user

            UserService.logon($scope.user).then(
                (value) ->
                    $log.info "RegistrationCtrl successfully logged in"
                    $log.debug
                        value: value

                (error) ->
                    $log.info "RegistrationCtrl error on login"

                    $translate('TOAST_MESSAGES.NOT_AUTHORIZED').then (translation) ->
                        ngToast.create
                            content: translation
                            className: "danger"
            )


        $('.input-group').on 'focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        .on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
