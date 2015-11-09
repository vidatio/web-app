"use strict"

app = angular.module("app.controllers")

app.controller "RegistrationCtrl", [
    "$scope"
    "UserFactory"
    "$log"
    ($scope, UserFactory, $log) ->
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
            , (error) ->
                #TODO Error message über formular

                $translate('TOAST_MESSAGES.')
                .then (translation) ->
                    ngToast.create(
                        content: translation
                        className: "danger"
                    )

                $log.error "RegistrationCtrl register error called"
                $log.debug
                    error: error

            $('.input-group').on 'focus', '.form-control', ->
                $(this).closest('.input-group, .form-group').addClass 'focus'
            .on 'blur', '.form-control', ->
                $(this).closest('.input-group, .form-group').removeClass 'focus'

]
