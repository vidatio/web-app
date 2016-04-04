"use strict"

class window.vidatio.Visualization

    # @method constructor
    constructor: (@dataset, @color = "#11DDC6", @width, @height, @containerSelector = "#chart") ->

    # @method remove
    remove: ->
        $(@containerSelector).empty()

    # @method preProcess
    # @param {Object} options
    #   @param {String} type
    #   @param {Integer} xColumn
    #   @param {Integer} yColumn
    #   @param {Object} headers
    #       @param {String} headers
    #       @param {String} headers
    preProcess: (options) ->
        { type, xColumn, yColumn, headers } = options
        @chartData = vidatio.helper.transformToArrayOfObjects @dataset, xColumn, yColumn, type, headers, @color


    visualizationToBase64String: ($targetElem) ->
        vidatio.log.info "Visualization visualizationToBase64String called"
        vidatio.log.debug
            targetElem: $targetElem

        if $targetElem.selector is "#map"
            return mapToImage $targetElem
        else
            return chartToImage $targetElem

    # @method mapToImg
    # @description converts the map visualization to a PNG / JPEG
    # @privat
    # @param {jQuery object} $targetElem
    # @return {Promise} A promise which resolves to an object and holds two properties: jpeg (containing the data-url for jpeg image) and png (containing the data-url for png image)
    mapToImage = ($targetElem) ->
        vidatio.log.info "Visualization mapToImage called"
        vidatio.log.debug
            targetElem: $targetElem

        return new Promise (resolve, reject) ->

            unless $targetElem.is ":visible"
                return reject
                    i18n: "TOAST_MESSAGES.VISUALIZATION.MAP_NOT_VISIBLE"

            html2canvas $targetElem,
            useCORS: true
            onrendered: (canvas) ->
                vidatio.log.info "Visualization html2canvas on targetElem onrendered callback called"

                str = $targetElem.find(".leaflet-map-pane").css("transform")
                mapArray = str.split('(')[1].split(')')[0].split(',')

                dyPopupOffset = 0
                ctx = canvas.getContext "2d"

                # checks if the map has areas (tiles)
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

                    # insert every marker in canvas
                    $imgElem.each (index, node) ->
                        if $(node).css("transform") isnt "none"
                            str = $(node).css "transform"
                            imgArray = str.split('(')[1].split(')')[0].split(',')

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

                    # values for directional triangle to marker which belongs to the popup
                    triangleWidth = 40
                    triangleHeight = 20

                    vidatio.log.debug
                        message: "ShareService html2canvas on popupElem gets called"
                        popupElem: $popupElem

                    unless $popupElem.is ":visible"
                        return reject
                            i18n: "TOAST_MESSAGES.VISUALIZATION.POPUP_NOT_VISIBLE"

                    # redraw popup on canvas because else the markers would be on top of the popup
                    html2canvas $popupElem,
                        useCORS: true
                        onrendered: (popupCanvas) ->
                            vidatio.log.info "ShareService html2canvas on popupElem onrendered callback called"

                            str = $popupElem.css "transform"
                            popupArray = str.split('(')[1].split(')')[0].split(',')

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
                            # draw popup with popupTipHeight offset
                            ctx.drawImage popupCanvas, dxPopup, dyPopup - popupTipHeight

                            dxTriangle = dxPopup + ($popupElem.width() / 2) - (triangleWidth / 2)
                            dyTriangle = dyPopup + $popupElem.height() - triangleHeight

                            # draw triangle / popup tip
                            ctx.beginPath()
                            ctx.moveTo dxTriangle, dyTriangle
                            ctx.lineTo dxTriangle + triangleWidth, dyTriangle
                            ctx.lineTo dxTriangle + (triangleWidth / 2), dyTriangle + triangleHeight
                            ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css "background-color"
                            ctx.fill()

                            dxRectangle = dxPopup
                            dyRectangle = dyPopup + $popupElem.find('.leaflet-popup-content-wrapper').outerHeight() - popupTipHeight

                            # draw recatangle
                            ctx.beginPath()
                            ctx.rect(dxRectangle, dyRectangle, rectangleWidth, rectangleHeight)
                            ctx.fillStyle = $popupElem.find('.leaflet-popup-content-wrapper').css "background-color"
                            ctx.fill()

                            return resolve
                                png: canvas.toDataURL "image/png"
                                jpg: canvas.toDataURL "image/jpeg"

                # map has no popup
                else
                    return resolve
                        png: canvas.toDataURL "image/png"
                        jpg: canvas.toDataURL "image/jpeg"


    # @method chartToImage
    # @description converts the chart visualization to a PNG / JPEG
    # @privat
    # @param {jQuery object} $targetElem
    # @return {Promise} A promise which resolves to an object and holds two properties: jpeg (containing the data-url for jpeg image) and png (containing the data-url for png image)
    chartToImage = ($targetElem) ->
        vidatio.log.info "Visualization chartToImage called"
        vidatio.log.debug
            targetElem: $targetElem

        $targetElemClone = $($targetElem).clone()

        if $targetElem.selector is "#chart svg"

            $canvasObject = $("#chart")

            canvas = $($canvasObject).find(".marks")[0]
            ctx = canvas.getContext "2d"

            canvas2 = $($canvasObject).find(".brushed")[0]
            canvas3 = $($canvasObject).find(".foreground")[0]
            canvas4 = $($canvasObject).find(".highlight")[0]


            ctx.drawImage canvas2, 0, 0
            ctx.drawImage canvas3, 0, 0
            ctx.drawImage canvas4, 0, 0
            ctx.drawSvg (new XMLSerializer).serializeToString($targetElemClone[0]), 0, 0

            return new Promise (resolve, reject) ->
                return resolve
                    png: canvas.toDataURL "image/png"
                    jpg: canvas.toDataURL "image/jpeg"

        else
            return new Promise (resolve, reject) ->
                Pablo($targetElemClone).dataUrl "png", (dataUrlPNG) ->
                    png = dataUrlPNG

                    Pablo($targetElemClone).dataUrl "jpeg", (dataUrlJPG) ->
                        jpg = dataUrlJPG

                        return resolve
                            png: png
                            jpg: jpg

    # @method download
    # @description creates a link element and automatically starts a download
    # @public
    # @param {sring} filename
    # @param {dataURL} dataURL
    download: (filename, dataURL) ->
        vidatio.log.info "Visualization download called"
        vidatio.log.debug
            filename: filename
            dataURL: dataURL

        aTag = document.createElement "a"
        aTag.setAttribute "href", dataURL
        aTag.setAttribute "download", filename

        if document.createEvent
            mouseEvent = document.createEvent "MouseEvents"
            mouseEvent.initEvent "click", true, true
            aTag.dispatchEvent mouseEvent
        else
            aTag.click()
