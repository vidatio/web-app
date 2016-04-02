"use strict"

app = angular.module("app.controllers")

app.controller "RegistrationCtrl", [
    "$scope"
    "UserFactory"
    "$log"
    "$translate"
    "ngToast"
    "$state"
    ($scope, UserFactory, $log, $translate, ngToast, $state) ->
        $scope.register = ->
            UserFactory.save $scope.user, (response) ->
                $translate('TOAST_MESSAGES.REGISTRATION_SUCCESS').then (translation) ->
                    ngToast.create
                        content: translation

                $state.go "app.login"
            , (error) ->
                $log.error "RegistrationCtrl register error called"
                $log.debug
                    error: error

                $translate('TOAST_MESSAGES.SERVER_ERROR').then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        $('.input-group').on 'focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        .on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
