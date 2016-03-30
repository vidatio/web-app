"use strict"

app = angular.module "app.controllers"

app.controller "LoginCtrl", [
    "$scope"
    "$rootScope"
    "UserService"
    "$state"
    "$translate"
    "ngToast"
    "$stateParams"
    ($scope, $rootScope, UserService, $state, $translate, ngToast) ->
        $scope.logon = ->
            UserService.logon($scope.user)
            .then (value) ->
                # Default routing for user at logout success
                unless $rootScope.history.length
                    return $state.go "app.index"
                # After login success we want to route the user to the last page except login and registration
                for element in $rootScope.history
                    element = $rootScope.history[$rootScope.history.length - 1]

                    unless element.name in ["app.login", "app.registration", ""]
                        # redirect to detailview needs vidatio-id, so an additional if is necessary to transfer the id
                        if element.name is "app.dataset"
                            return $state.go element.name, "id": element.params.id, element.params.locale
                        return $state.go element.name, element.params.locale
                    return $state.go "app.index"
            .catch (error) ->
                $translate('TOAST_MESSAGES.NOT_AUTHORIZED').then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"

        # To give the prepends tags of flat ui the correct focus style
        $ "#login .input-group"
        .on "focus", ".form-control", ->
            $(this).closest(".input-group, .form-group").addClass "focus"
        .on "blur", ".form-control", ->
            $(this).closest(".input-group, .form-group").removeClass "focus"
]
