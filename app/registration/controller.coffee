"use strict"

app = angular.module("app.controllers")

app.controller "RegistrationCtrl", [
    "$scope"
    "UserFactory"
    "UserService"
    "$log"
    "$translate"
    "ngToast"
    ($scope, UserFactory, UserService, $log, $translate, ngToast) ->
        $log.info "RegistrationCtrl called"

        $scope.register = ->
            $log.info "RegistrationCtrl register called"

            UserFactory.save
                "email": $scope.user.email
                "name": $scope.user.name
                "password": $scope.user.password
            , (response) ->
                $log.info "RegistrationCtrl register success called"
                $log.debug
                    response: response

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
