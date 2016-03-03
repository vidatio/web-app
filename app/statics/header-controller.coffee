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
            Data.meta.fileName = translation + "_" +  moment().format("L") + "_" + moment().format("LT")

        # @method saveVidatioTitle
        # @description set the vidatio-title according to the users' input
        $scope.saveVidatioTitle = ->
            Data.meta.fileName = $scope.vidatioTitle

        # the following lines are a solution from stack-overflow
        # the input-field width automatically resizes according to a users' input
        $.fn.textWidth = (text, font) ->
            if !$.fn.textWidth.fakeEl
                $.fn.textWidth.fakeEl = $("<span>").hide().appendTo(document.body)
            $.fn.textWidth.fakeEl.text(text or @val() or @text()).css "font", font or @css("font")
            $.fn.textWidth.fakeEl.width()

        # eventlistener to call the resize function of the input-element above
        $("#vidatio-title").on("input", ->
            paddingBetweenLetters = 10 # works as a minimum width
            valWidth = $(this).textWidth() + paddingBetweenLetters + "px"
            $("#vidatio-title").css "width", valWidth
            $(".underline-title").css "width", valWidth
            return
        ).trigger "input"

        # remove edit-icon on first click at the input-field
        $("#vidatio-title").click ->
            $(".icon-vidatio-title").css "display", "none"
            return
]
