# Header Controller
# ===================

app = angular.module "app.controllers"

app.controller "HeaderCtrl", [
    "$scope"
    "$rootScope"
    "$timeout"
    "MapService"
    "DataService"
    "$log"
    "ngToast"
    "$translate"
    ($scope, $rootScope, $timeout, Map, Data, $log, ngToast, $translate) ->

        #$scope.saveDataset = ->
        #    geoJSON = Map.getGeoJSON()
        #    Data.saveViaAPI geoJSON

        #$scope.hideLink = ->
        #    $rootScope.showLink = false

        #$scope.copyLink = ->
        #    $log.info "HeaderCtrl copyLink called"
        #    window.getSelection().removeAllRanges()
        #    link = document.querySelector '#link'
        #    range = document.createRange()
        #    range.selectNode link
        #    window.getSelection().addRange(range)

        #    try
        #        successful = document.execCommand 'copy'

        #        $log.debug
        #            message: "HeaderCtrl copyLink copy link to clipboard"
        #            successful: successful

        #        $translate('TOAST_MESSAGES.LINK_COPIED')
        #            .then (translation) ->
        #                ngToast.create
        #                    content: translation
        #    catch err
        #        $log.info "Link could not be copied"
        #        $log.error
        #            error: error

        #    window.getSelection().removeAllRanges()

        $scope.saveVidatioTitle = ->
            $scope.vidatioTitle = $('#vidatio-title').val() || "Neues Vidatio"
            console.log $scope.vidatioTitle

        # the following lines are a solution from stack-overflow
        # the input-field width automatically resizes according to a users' input
        $.fn.textWidth = (text, font) ->
            if !$.fn.textWidth.fakeEl
                $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body)
            $.fn.textWidth.fakeEl.text(text or @val() or @text()).css 'font', font or @css('font')
            $.fn.textWidth.fakeEl.width()

        # eventlistener to call the resize function of the input-element above
        $('#vidatio-title').on('input', ->
            paddingBetweenLetters = 10 # works as a minimum width
            valWidth = $(this).textWidth() + paddingBetweenLetters + 'px'
            $('#vidatio-title').css 'width', valWidth
            $('.underline-title').css 'width', valWidth
            return
        ).trigger 'input'

        # remove edit-icon on first click at the input-field
        $('#vidatio-title').click ->
            $('.icon-vidatio-title').css 'display', 'none'
            return
]
