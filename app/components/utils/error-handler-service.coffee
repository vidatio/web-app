"use strict"

app = angular.module "app.services"

app.service "ErrorHandler", [
    "$translate"
    "ngToast"
    ($translate, ngToast) ->

        format: (errors) ->
            if errors.status? and errors.status is 401
                $translate("API.SAVE")
                .then (translation) ->
                    ngToast.create
                        content: translation
                        className: "danger"
            else
                for error in errors.data.error.errors
                    for key, value of error
                        $translate(error["#{key}"].i18n)
                        .then (translation) ->
                            ngToast.create
                                content: translation
                                className: "danger"
]
