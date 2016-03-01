# # Share Service

"use strict"

app = angular.module "app.services"

app.service "ShareService", [
    "$q"
    "$log"
    "ConverterService"
    "$translate"
    ($q, $log, Converter, $translate) ->
        class Share

            # @method mapToImg
            # @description converts the map visualization to a PNG / JPEG with a given quality measurement.
            # @public
            # @param {jQuery object} $targetElem
            # @param {integer} quality Quality is between 0 and 1 where 1 means 100% Quality and 0 means 0% Quality. This value is only used for Jpeg.
            # @return {Promise} A promise which resolves to an object and holds two properties: jpeg (containing the data-url for jpeg image) and png (containing the data-url for png image)
            mapToImg: ($targetElem, quality = 1.0) ->
                $log.info "ShareService mapToImg called"
                $log.debug
                    message: "ShareService mapToImg called"
                    targetElem: $targetElem
                    quality: quality

                deferred  = $q.defer()

                unless $targetElem.is ":visible"
                    $translate("TOAST_MESSAGES.SHARE_SERVICE.MAP_NOT_VISIBLE").then (translation) ->
                        deferred.reject translation
                    return deferred.promise

                html2canvas $targetElem,
                useCORS: true
                onrendered: (canvas) ->
                    $log.info "ShareService html2canvas on targetElem onrendered callback called"
                    deferred.notify $translate.instant('OVERLAY_MESSAGES.SHARE_SERVICE.MAP_TO_CANVAS')

                    mapArray = Converter.matrixToArray $targetElem.find(".leaflet-map-pane").css("transform")
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
                                imgArray = Converter.matrixToArray $(node).css "transform"

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

                        $log.debug
                            message: "ShareService html2canvas on popupElem gets called"
                            popupElem: $popupElem

                        unless $popupElem.is ":visible"
                            $translate('TOAST_MESSAGES.SHARE_SERVICE.POPUP_NOT_VISIBLE').then (translation) ->
                                deferred.reject translation
                            return deferred.promise

                        # redraw popup on canvas because else the markers would be on top of the popup
                        html2canvas $popupElem,
                            useCORS: true
                            onrendered: (popupCanvas) ->
                                $log.info "ShareService html2canvas on popupElem onrendered callback called"

                                popupArray = Converter.matrixToArray $popupElem.css "transform"

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

                                deferred.resolve
                                    png: canvas.toDataURL "image/png"
                                    jpg: canvas.toDataURL "image/jpeg", quality

                    # map has no popup
                    else
                        deferred.resolve
                            png: canvas.toDataURL "image/png"
                            jpg: canvas.toDataURL "image/jpeg", quality

                return deferred.promise

            # @method download
            # @description creates a link element and automatically starts a download
            # @public
            # @param {sring} filename
            # @param {dataURL} dataURL
            download: (filename, dataURL) ->
                $log.info "ShareService download called"
                $log.debug
                    message: "ShareService download called"
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

        new Share
]
