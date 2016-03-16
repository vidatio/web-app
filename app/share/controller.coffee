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

        $scope.share = Data

        # initialize tagsinput on page-init for propper displaying the tagsinput-field
        $(".tagsinput").tagsinput()

        #to remove tags label on focus & remove flag-ui tags-input length
        $('.tagsinput-primary ').on 'focus', '.bootstrap-tagsinput input', ->
            $('span.placeholder').hide()
            $(this).attr('style', 'width:auto')

        #to change color after user selection (impossible with css)
        $('.selection select').change -> $(this).addClass 'selected'

        #plus-button for tags-input
        $('.add-tag').click -> $('.bootstrap-tagsinput input').focus()

        #flat-ui checkbox
        $('#publish').radiocheck()

        # copied from login controller, redundant?
        # To give the prepends tags of flat ui the correct focus style
        $('.input-group').on('focus', '.form-control', ->
            $(this).closest('.input-group, .form-group').addClass 'focus'
        ).on 'blur', '.form-control', ->
            $(this).closest('.input-group, .form-group').removeClass 'focus'
]
