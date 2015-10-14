# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    ($scope, Map) ->
        $scope.shareVisualization = ->
            $map = $("#map")
            svgToCanvas $map
]

svgToCanvas = ($targetElem) ->
    html2canvas $targetElem,
        useCORS: true
        onrendered: (canvas) ->
            mapArray = matrixToArray $targetElem.find(".leaflet-map-pane").css("transform")
            dyPopupOffset = 0
            ctx = canvas.getContext "2d"

            # checks if the map has areas
            if $targetElem.find(".leaflet-overlay-pane").children().length > 0
                $svgElem = $targetElem.find "svg"

                $svgElem.find("path").each (index, element) ->
                    $current = $ element
                    $current.css
                        "stroke": $current.css "stroke"
                        "stroke-opacity": $current.css "stroke-opacity"
                        "fill": $current.css "fill"
                        "fill-opacity": $current.css "fill-opacity"
                        "stroke-width": $current.css "stroke-width"
                        "stroke-dasharray": $current.css "stroke-dasharray"

                # calculates the offset to place the areas correct
                dx = ($targetElem.width() - $svgElem.width()) / 2
                dy = ($targetElem.height() - $svgElem.height()) / 2

                ctx.drawSvg (new XMLSerializer).serializeToString($svgElem[0]), dx, dy

            else if $targetElem.find(".leaflet-marker-pane").children().length > 0
                $imgElem = $targetElem.find ".leaflet-marker-icon"

                $imgElem.each (index, node) ->
                    if $(node).css("transform") isnt "none"
                        imgArray = matrixToArray $(node).css "transform"

                        dxOffset = parseInt $(node).css "margin-left"
                        dyOffset = parseInt $(node).css "margin-top"

                        dx = parseInt(imgArray[4]) + parseInt(mapArray[4])
                        dy = parseInt(imgArray[5]) + parseInt(mapArray[5])

                        dx += dxOffset
                        dy += dyOffset

                        ctx.drawImage node, dx, dy

                        dyPopupOffset = $targetElem.find(".leaflet-marker-icon").height()

            if $targetElem.find(".leaflet-popup").children().length > 0
                $popupElem = $targetElem.find '.leaflet-popup'
                $test = $targetElem.find '.leaflet-popup'
                # popupElemClone = $popupElem.clone()[0]
                popupElemClone = {}
                $.extend true, popupElemClone, $popupElem
                # popupElemClone[0].removeChild popupElemClone.find('.leaflet-popup-tip')
                # popupElemClone[0].removeChild popupElemClone.find('.leaflet-popup-tip-container')
                popupElemClone.find('.leaflet-popup-tip').remove()

                triangleWidth = 40
                triangleHeight = 20

                $(popupElemClone).css(
                    position: "absolute"
                    left: "-10000px"
                    ).appendTo("body")

                html2canvas popupElemClone,
                    useCORS: true
                    onrendered: (popupCanvas) ->
                        # console.log "popupCanvas", popupCanvas.getContext "2d"
                        # popupContext = popupCanvas.getContext "2d"
                        # finder popupContext.canvas.ownerDocument.all

                        popupArray = matrixToArray $popupElem.css "transform"

                        dxPopup = parseInt(popupArray[4]) + parseInt(mapArray[4])
                        dyPopup = parseInt(popupArray[5]) + parseInt(mapArray[5])

                        console.log "dxPopup, dyPopup", dxPopup, dyPopup

                        dxOffset = parseInt $popupElem.css "left"
                        dyOffset = $popupElem.height() + dyPopupOffset

                        console.log "dxOffset, dyOffset", dxOffset, dyOffset

                        if dyPopupOffset == 0
                            dyOffset += parseInt($popupElem.css("bottom"))

                        dxPopup += dxOffset
                        dyPopup -= dyOffset

                        console.log "dxPopup, dyPopup", dxPopup, dyPopup
                        console.log popupCanvas

                        console.log ctx
                        ctx = canvas.getContext "2d"
                        console.log ctx
                        ctx.drawImage popupCanvas, dxPopup, dyPopup

                        dxTriangle = dxPopup + ($popupElem.width() / 2) - (triangleWidth / 2)
                        dyTriangle = dyPopup + $popupElem.height() - triangleHeight

                        ctx.beginPath()
                        ctx.moveTo dxTriangle, dyTriangle
                        ctx.lineTo dxTriangle + triangleWidth, dyTriangle
                        ctx.lineTo dxTriangle + (triangleWidth / 2), dyTriangle + triangleHeight
                        ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css "background-color"
                        ctx.fill()


                        png2 = canvas.toDataURL "image/png"
                        $("body").append '<img src="' + png2 + '"/>'

            png = canvas.toDataURL "image/png"
            $("body").append '<img src="' + png + '"/>'

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

finder = (array) ->
    # console.log array.length
    # for i in [0..array.length - 1]
    #     if array[i].getAttribute("class") == "leaflet-popup-tip-container" or array[i].getAttribute("class") == "leaflet-popup-tip"
    #         console.log "found class", i

    #         array[i].remove()

    #         return
    x = Array.prototype.slice.call array, 0
    for d, i in x
        if d.getAttribute("class") == "leaflet-popup-tip-container" or d.getAttribute("class") == "leaflet-popup-tip"
            x.splice i, 1
