# Home Controller
# ===============

"use strict"

app = angular.module "app.controllers"

app.controller "HomeCtrl", [
    "$scope",
    "$rootScope"
    "UserService",
    "AuthenticationService"
    "$state"
    ($scope, $rootScope, UserService, AuthenticationService, $state) ->

        $scope.loginData = {}

        $scope.alerts = login: []

        $scope.datepickerOpened = false
        $scope.dateOptions =
            startingDay: 1
            datepickerMode: "year"

        $scope.openDatepicker = ($event) ->
            $event.preventDefault()
            $event.stopPropagation()

            $scope.datepickerOpened = true

        $scope.login = ->

            AuthenticationService.ClearCredentials()

            if $scope.loginForm.$invalid
                if $scope.loginForm.name.$error.required
                    $scope.alerts.login.push
                        type: "danger"
                        message: "Name is required."
                    return
                if $scope.loginForm.password.$error.required
                    $scope.alerts.login.push
                        type: "danger"
                        message: "Password is required."
                    return
                if $scope.loginForm.password.$error.minlength
                    $scope.alerts.login.push
                        type: "danger"
                        message: "Password must have at least 3 characters."
                    return

            # proceed login
            AuthenticationService.SetCredentials(
                $scope.loginData.name, $scope.loginData.password
            )
            UserService.init( $scope.loginData ).then(
                (value) ->
                    $scope.alerts.login.push
                        type: "success"
                        message: "You are now logged in."

                    $state.go "penguins"
                (error) ->
                    $scope.alerts.login.push
                        type: "danger"
                        message: "Name/Password invalid."
            )

        $scope.cancelAlert = (field, index) ->
            $scope.alerts[field].splice index, 1

]
