# Share Controller
# ===================

"use strict"

app = angular.module "app.controllers"

app.controller "ShareCtrl", [
    "$scope"
    "MapService"
    ($scope, Map) ->
        console.log "ctrl"
        $scope.shareVisualization = ->
            console.log "shareVisualization"
            map = Map.map
            console.log "map", map

            # html2canvas(document.getElementById("map")) (canvas) ->
                # document.body.appendChild canvas

            svgToCanvas $("#map")

            # html2canvas document.getElementById("map"),
            #     useCORS: true
            #     onrendered: (canvas) ->
            #         console.log canvas
            #         # document.getElementById("editor").appendChild canvas
            #         png = canvas.toDataURL "image/png"
            #         document.write('<img src="'+png+'"/>')

]

svgToCanvas = (targetElem) ->

    nodesToRecover = []
    nodesToRemove = []

    svgElem = targetElem.find 'svg'

    svgElem.each (index, node) ->

        parentNode = node.parentNode
        svg = parentNode.innerHTML

        canvas = document.createElement('canvas')

        console.log svg
        canvg canvas, (new XMLSerializer).serializeToString(node)
        # canvg canvas, svg

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

            ## IF IT IS SHAPE WITH AREA
            ctx = canvas.getContext('2d');
            ctx.drawImage($("canvas.leaflet-zoom-animated")[0], 0,0)
            png = canvas.toDataURL "image/png"
            $("body").append '<img src="' + png + '"/>'

            ## IF IT IS FILE WITH MARKERS ONLY
            # png = canvas.toDataURL "image/png"
            # $("body").append '<img src="' + png + '"/>'

