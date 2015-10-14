# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    ($scope, Map) ->
        $scope.shareVisualization = ->
            exportCanvas = svgToCanvas($("#map"))
]

svgToCanvas = (targetElem) ->
    html2canvas targetElem,
        useCORS: true
        onrendered: (canvas) ->
            mapArray = matrixToArray $(".leaflet-map-pane").css("transform")
            dyPopupOffset = 0
            console.log "mapArray", mapArray
            # checks if the map has areas
            if targetElem.find('.leaflet-overlay-pane').children().length > 0
                $svgElem = targetElem.find 'svg'

                $svgElem.find('path').each (index, element) ->
                    $current =   $(element)
                    $current.css
                        'stroke': $current.css 'stroke'
                        'stroke-opacity': $current.css 'stroke-opacity'
                        'fill': $current.css 'fill'
                        'fill-opacity': $current.css 'fill-opacity'
                        'stroke-width': $current.css 'stroke-width'
                        'stroke-dasharray': $current.css 'stroke-dasharray'

                ctx = canvas.getContext('2d')

                dw = $($svgElem).width()
                dh = $($svgElem).height()

                console.log "dw, dh", dw, dh

                # calculates the offset to place the areas correct
                dx = ($("#map").width() - $($svgElem).width()) / 2
                dy = ($("#map").height() - $($svgElem).height()) / 2

                ctx.drawSvg((new XMLSerializer).serializeToString($svgElem[0]), dx, dy)

            else if targetElem.find('.leaflet-marker-pane').children().length > 0
                $imgElem = targetElem.find '.leaflet-marker-icon'

                ctx = canvas.getContext('2d')

                $imgElem.each (index, node) ->
                    if $(node).css("transform") != "none"
                        imgArray = matrixToArray $(node).css("transform")

                        dxOffset = parseInt $(node).css("margin-left")
                        dyOffset = parseInt $(node).css("margin-top")

                        dx = parseInt(imgArray[4]) + parseInt(mapArray[4])
                        dy = parseInt(imgArray[5]) + parseInt(mapArray[5])

                        dx += dxOffset
                        dy += dyOffset

                        console.log "dx, dy", dx, dy

                        ctx.drawImage node, dx, dy

                        dyPopupOffset = $('.leaflet-marker-icon').height()

            if $('#map').find('.leaflet-popup').children().length > 0
                $popupElem = $('#map').find '.leaflet-popup'
                popupElem = $popupElem.clone()[0]

                console.log popupElem
                popupElem.removeChild popupElem.lastChild

                console.log $popupElem
                console.log popupElem

                html2canvas popupElem,
                    useCORS: true
                    onrendered: (popupCanvas) ->
                        ctx = canvas.getContext('2d')

                        popupArray = matrixToArray $(popupElem).css("transform")
                        console.log "$(popupElem)", $(popupElem)
                        console.log "popupArray", popupArray

                        dxPopup = parseInt(popupArray[0]) + parseInt(mapArray[4])
                        dyPopup = parseInt(popupArray[1]) + parseInt(mapArray[5])

                        console.log "Popup: dx, dy", dxPopup, dyPopup

                        dxOffset = parseInt $(popupElem).css("left")
                        dyOffset = $popupElem.height() + dyPopupOffset

                        if dyPopupOffset == 0
                            dyOffset += parseInt $(popupElem).css("bottom")

                        console.log "dxOffset, dyOffset", dxOffset, dyOffset

                        dxPopup += dxOffset
                        dyPopup -= dyOffset

                        console.log "Popup: dx, dy", dxPopup, dyPopup

                        ctx.drawImage popupCanvas, dxPopup, dyPopup

                        console.log $popupElem.width()
                        console.log $popupElem.find('.leaflet-popup-content-wrapper').css("background-color")

                        dxTriangle = dxPopup + ($popupElem.width() / 2) - 20
                        dyTriangle = dyPopup + $popupElem.height() - 20
                        console.log dxTriangle
                        console.log dyTriangle
                        ctx.beginPath()
                        ctx.moveTo dxTriangle, dyTriangle
                        ctx.lineTo dxTriangle + 40, dyTriangle
                        ctx.lineTo dxTriangle + 20, dyTriangle + 20
                        ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css("background-color")
                        ctx.fill()


                        png2 = canvas.toDataURL "image/png"
                        $("body").append '<img src="' + png2 + '"/>'

            png = canvas.toDataURL "image/png"
            $("body").append '<img src="' + png + '"/>'

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

