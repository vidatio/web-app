"use strict"

app = angular.module "app.controllers"

app.controller "LoginCtrl", [
    "$scope"
    "UserService"
    "UserFactory"
    "ErrorHandler"
    "$translate"
    "ngToast"
    ($scope, UserService, UserFactory, ErrorHandler, $translate, ngToast) ->

        $scope.logon = ->
            UserService.logon($scope.user)
            .then (user) ->
                return $translate('TOAST_MESSAGES.LOGIN_SUCCESS', { name: user.name }).then (translation) ->
                    ngToast.create content: translation

            .catch (error) ->
                return $translate('TOAST_MESSAGES.NOT_AUTHORIZED').then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        $scope.register = ->
            UserFactory.save $scope.user, (response) ->
                $translate('TOAST_MESSAGES.REGISTRATION_SUCCESS').then (translation) ->
                    ngToast.create content: translation

                # if registration was successful call private logon-function
                $scope.logon()
            , (error) ->
                return ErrorHandler.format error

        # To give the prepends tags of flat ui the correct focus style
        angular.element ".input-group"
        .on "focus", ".form-control", ->
            $(this).closest(".input-group, .form-group").addClass "focus"
        .on "blur", ".form-control", ->
            $(this).closest(".input-group, .form-group").removeClass "focus"

        # terms checkbox
        $("#terms").radiocheck()
]
