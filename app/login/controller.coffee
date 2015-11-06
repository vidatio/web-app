"use strict"

app = angular.module("app.controllers")

app.controller "LoginCtrl", [
    "$scope"
    ($scope, UserFactory) ->
        $scope.logon = ->
            # TODO

        #Needed for flat UI prepend tags
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
