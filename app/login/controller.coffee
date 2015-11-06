"use strict"

app = angular.module("app.controllers")

app.controller "RegistrationCtrl", [
    "$scope"
    ($scope, UserFactory) ->
        $scope.register = ->
            UserFactory.save {"mail": user.mail, "name": user.name, "password": user.password }

        #Needed for flat UI prepend tags
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
