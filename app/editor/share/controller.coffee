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

            # checks if map has markers
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

            # checks if map has a popup
            if $targetElem.find(".leaflet-popup").children().length > 0
                $popupElem = $targetElem.find '.leaflet-popup'

                triangleWidth = 40
                triangleHeight = 20

                html2canvas $popupElem,
                    useCORS: true
                    onrendered: (popupCanvas) ->
                        popupArray = matrixToArray $popupElem.css "transform"

                        dxPopup = parseInt(popupArray[4]) + parseInt(mapArray[4])
                        dyPopup = parseInt(popupArray[5]) + parseInt(mapArray[5])

                        dxOffset = parseInt $popupElem.css "left"
                        dyOffset = $popupElem.height() + dyPopupOffset

                        if dyPopupOffset == 0
                            dyOffset += parseInt($popupElem.css("bottom"))

                        dxPopup += dxOffset
                        dyPopup -= dyOffset

                        rectangleHeight = $popupElem.height() - $popupElem.find('.leaflet-popup-content-wrapper').height()
                        rectangleWidth = $popupElem.width()

                        popupTipHeight = $popupElem.find('.leaflet-popup-tip-container').height()
                        ctx.drawImage popupCanvas, dxPopup, dyPopup - popupTipHeight

                        dxTriangle = dxPopup + ($popupElem.width() / 2) - (triangleWidth / 2)
                        dyTriangle = dyPopup + $popupElem.height() - triangleHeight

                        # Draw Triangle / Popup Tip
                        ctx.beginPath()
                        ctx.moveTo dxTriangle, dyTriangle
                        ctx.lineTo dxTriangle + triangleWidth, dyTriangle
                        ctx.lineTo dxTriangle + (triangleWidth / 2), dyTriangle + triangleHeight
                        ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css "background-color"
                        ctx.fill()

                        dxRectangle = dxPopup
                        dyRectangle = dyPopup + $popupElem.find('.leaflet-popup-content-wrapper').outerHeight() - popupTipHeight

                        ctx.beginPath()
                        ctx.rect(dxRectangle, dyRectangle, rectangleWidth, rectangleHeight)
                        ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css "background-color"
                        ctx.fill()

                        png = canvas.toDataURL "image/png"
                        # $("body").append '<img src="' + png2 + '"/>'
                        download "Vidatio_Visualization", png

            else
                png = canvas.toDataURL "image/png"
                # $("body").append '<img src="' + png + '"/>'
                download "Vidatio_Visualization", png

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

download = (filename, text) ->
    pom = document.createElement 'a'
    pom.setAttribute('href', text)
    pom.setAttribute('download', filename)

    if document.createEvent
        event = document.createEvent 'MouseEvents'
        event.initEvent 'click', true, true
        pom.dispatchEvent event
    else
        pom.click()

