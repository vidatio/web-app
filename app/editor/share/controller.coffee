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

    nodesToRecover = []
    nodesToRemove = []

    svgElem = targetElem.find 'svg'

    svgElem.each (index, node) ->

        parentNode = node.parentNode
        svg = parentNode.innerHTML

        canvas = document.createElement('canvas')

        dw = $(node).width()
        dh = $(node).height()

        canvg canvas, (new XMLSerializer).serializeToString(node),
            scaleWidth: dw
            scaleHeight: dh

        nodesToRecover.push
            parent: parentNode
            child: node

        parentNode.removeChild node

        nodesToRemove.push
            parent: parentNode
            child: canvas

        parentNode.appendChild canvas

    html2canvas targetElem,
        useCORS: true
        onrendered: (canvas) ->

            # checks if the map has areas
            if $("canvas.leaflet-zoom-animated").length > 0
                ctx = canvas.getContext('2d')

                # calculates the offset to place the areas correct
                diffHeight = ($("canvas").height() - $("#map").height()) / 2
                diffWidth = ($("canvas").width() - $("#map").width()) / 2

                ctx.drawImage($("canvas.leaflet-zoom-animated")[0], -diffWidth, -diffHeight)
                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'
            else
                # svgElem = targetElem.find 'svg'

                # ctx = canvas.getContext('2d')

                # svgElem.each (index, node) ->

                #     parentNode = node.parentNode
                #     svg = parentNode.innerHTML

                #     dw = $(parentNode).width()
                #     dh = $(parentNode).height()

                #     ctx.drawSvg((new XMLSerializer).serializeToString(node), 0, 0, dw, dh)

                png = canvas.toDataURL "image/png"
                $("body").append '<img src="' + png + '"/>'

