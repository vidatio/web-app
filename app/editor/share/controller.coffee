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

    html2canvas targetElem,
        useCORS: true
        onrendered: (canvas) ->

            # checks if the map has areas
            if $(".leaflet-overlay-pane").children().length > 0
                svgElem = targetElem.find 'svg'

                ctx = canvas.getContext('2d')

                # svgElem.each (index, node) ->

                parentNode = svgElem.parentNode
                # svg = parentNode.innerHTML

                dw = $(svgElem).width()
                dh = $(svgElem).height()

                console.log "dw, dh", dw, dh

                # calculates the offset to place the areas correct
                dx = ($("#map").width() - $(svgElem).width()) / 2
                dy = ($("#map").height() - $(svgElem).height()) / 2

                ctx.drawSvg((new XMLSerializer).serializeToString(svgElem[0]), dx, dy)

                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'
            else if $(".leaflet-marker-pane").children().length > 0
                imgElem = targetElem.find '.leaflet-marker-icon'

                ctx = canvas.getContext('2d')

                mapArray = matrixToArray $(".leaflet-map-pane").css("transform")

                imgElem.each (index, node) ->
                    if $(node).css("transform") != "none"
                        imgArray = matrixToArray $(node).css("transform")

                        dxOffset = parseInt $(node).css("margin-left")
                        dyOffset = parseInt $(node).css("margin-top")

                        dx = parseInt(imgArray[4]) + parseInt(mapArray[4])
                        dy = parseInt(imgArray[5]) + parseInt(mapArray[5])

                        dx = dx + dxOffset
                        dy = dy + dyOffset

                        console.log "dx, dy", dx, dy

                        ctx.drawImage node, dx, dy

                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'

            else
                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

