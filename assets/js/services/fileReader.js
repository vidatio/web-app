angular.module("vidatio").service("FileReaderService",
  ["$q", function ($q) {

    function Reader() {
      this.reader = undefined;
      this.deferred = undefined;
      this.progress = 0
    }

    Reader.prototype.readAsDataUrl = function (file) {

      // maybe there's a scope apply necessary here
      this.deferred = $q.defer();
      this.reader =
      this.progress = 0;

      var that = this;
      this.reader.onload = function () {
        that.deferred.resolve(that.reader.result);
      }

      this.reader.onerror = function () {
        that.deferred.reject(that.reader.result);
      }

      this.reader.onprogress = function (event) {
        this.progress = event.loaded/event.total;
      }

      this.reader.readAsText(file);
      return this.deferred.promise;
    }

    return new Reader;
  }]
);
