# File-Reader Service
# ======================

"use strict"

app = angular.module "app.services"

app.service 'FileReader', [
    "$q"
    ($q) ->

      Reader ->
        this.reader = new FileReader()
        this.deferred = undefined
        this.progress = 0

      Reader.prototype.readAsDataUrl -> (file)
        this.deferred = $q.defer()
        this.progress = 0

        this.reader.onload ->
          this.deferred.resolve this.reader.result
        .bind(this)

        this.reader.onerror ->
          this.deferred.reject this.reader.result
        .bind(this)

        this.reader.onprogress -> (event)
          this.progress = event.loaded / event.total
        .bind(this)

        this.reader.readAsText file
        this.deferred.promise

      new Reader()
]
