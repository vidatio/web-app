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

        # set a standardisized vidatio-title on page enter
        $translate("NEW_VIDATIO")
        .then (translation) ->
            $scope.standardTitle = translation + "_" + moment().format('DD/MM/YYYY') + "_" + moment().format("HH:MM")
            Data.meta.fileName = $scope.standardTitle

        # @method saveVidatioTitle
        # @description set the users' input (if existing) as vidatio-title; set a standard-title otherwise
        $scope.saveVidatioTitle = ->
            $log.info "HeaderCtrl saveVidatioTitle called"

            if $scope.vidatioTitle == ""
                Data.meta.fileName = $scope.standardTitle
            else
                Data.meta.fileName = $scope.vidatioTitle

            $log.debug
                filename: Data.meta.fileName

        # the input-field width automatically resizes according to a users' input
        $.fn.textWidth = (text, font) ->
            if !$.fn.textWidth.fakeEl
                $.fn.textWidth.fakeEl = $("<span>").hide().appendTo(document.body)
            $.fn.textWidth.fakeEl.text(text or @val() or @text()).css "font", font or @css("font")
            $.fn.textWidth.fakeEl.width()

        # eventlistener to call the resize function of the input-element above
        $("#vidatio-title").on("input", ->
            paddingBetweenLetters = 10 # works as a minimum width
            valWidth = $(@).textWidth() + paddingBetweenLetters + "px"
            $("#vidatio-title").css "width", valWidth
            $(".underline-title").css "width", valWidth
            return
        ).trigger "input"
]
