# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "$translate"
    "$rootScope"
    "DataService"
    ($scope, $translate, $rootScope, Data) ->

        #to remove tags label on focus & remove flag-ui tags-input length
        $('.tagsinput-primary ').on 'focus', '.bootstrap-tagsinput input', ->
            $('span.placeholder').hide()
            $(this).attr('style', 'width:auto')
        #to change color after user selection (impossible with css)
        $('.selection select').change -> $(this).addClass 'selected'
        #plus-button for tags-input
        $('.add-tag').click -> $('.bootstrap-tagsinput input').focus()
]
