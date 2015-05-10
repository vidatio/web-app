angular.module("vidatio").service("FileReaderService",
  ["$q", function ($q) {

    function Reader() {
      this.reader = undefined;
      this.deferred = undefined;
      this.progress = {
        total: 100,
        loaded: 0
      }
    }

    Reader.prototype.getProgress = function(){
      return this.progress.loaded/this.progress.total;
    };

    Reader.prototype.readAsDataUrl = function (file) {

      // maybe there's a scope apply necessary here
      this.deferred = $q.defer();
      this.reader = new FileReader();
      this.progress = {
        total: 100,
        loaded: 0
      }

      var that = this;
      this.reader.onload = function () {
        that.deferred.resolve(that.reader.result);
      }

      this.reader.onerror = function () {
        that.deferred.reject(that.reader.result);
      }

      this.reader.onprogress = function (event) {
        that.progress.total = event.total;
        that.progress.loaded = event.loaded;
      }

      this.reader.readAsText(file);
      return this.deferred.promise;
    }

    return new Reader;
  }]
);
