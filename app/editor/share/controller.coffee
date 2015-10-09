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

    # nodesToRecover = []
    # nodesToRemove = []

    # svgElem = targetElem.find 'svg'

    # svgElem.each (index, node) ->

    #     parentNode = node.parentNode
    #     svg = parentNode.innerHTML

    #     canvas = document.createElement('canvas')

    #     dw = $(node).width()
    #     dh = $(node).height()

    #     canvg canvas, (new XMLSerializer).serializeToString(node),
    #         scaleWidth: dw
    #         scaleHeight: dh

    #     nodesToRecover.push
    #         parent: parentNode
    #         child: node

    #     parentNode.removeChild node

    #     nodesToRemove.push
    #         parent: parentNode
    #         child: canvas

    #     parentNode.appendChild canvas

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

                console.log "dx, dy", dx, dy

                # ctx.drawImage($("canvas.leaflet-zoom-animated")[0], -diffWidth, -diffHeight)
                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'
            else if $(".leaflet-marker-pane").children().length > 0
                imgElem = targetElem.find '.leaflet-marker-icon'

                ctx = canvas.getContext('2d')

                mapArray = matrixToArray $(".leaflet-map-pane").css("transform")

                imgElem.each (index, node) ->
                    if $(node).css("transform") != "none"
                        imgArray = matrixToArray $(node).css("transform")

                        # calculate marker position
                        # console.log imgArray
                        # console.log mapArray

                        dx = parseInt(imgArray[4]) + parseInt(mapArray[4])
                        dy = parseInt(imgArray[5]) + parseInt(mapArray[5])

                        console.log "dx, dy", dx, dy

                        ctx.drawImage node, dx, dy

                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'

            else
                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'

matrixToArray = (str) ->
    return str.split('(')[1].split(')')[0].split(',')

