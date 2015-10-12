# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    ($scope, Map) ->
        $scope.shareVisualization = ->
            svgToCanvas $("#map")
]

svgToCanvas = (targetElem) ->

    exportCanvas = null

    html2canvas targetElem,
        useCORS: true
        onrendered: (canvas) ->

            exportCanvas = canvas

            # checks if the map has areas
            if $(".leaflet-overlay-pane").children().length > 0
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

            else if $(".leaflet-marker-pane").children().length > 0
                $imgElem = targetElem.find '.leaflet-marker-icon'

                ctx = canvas.getContext('2d')

                mapArray = matrixToArray $(".leaflet-map-pane").css("transform")

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

            if $(".leaflet-popup").length > 0
                $popupElem = targetElem.find '.leaflet-popup'

                console.log exportCanvas
                html2canvas $popupElem,
                    useCORS: true
                    onrendered: (popupCanvas) ->
                        ctx = exportCanvas.getContext('2d')
                        console.log ctx
                        ctx.drawImage popupCanvas, 0,0
                        console.log exportCanvas


            console.log exportCanvas
            png = exportCanvas.toDataURL "image/png"
            $("body").append '<img src="' + png + '"/>'

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

