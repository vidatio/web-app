angular.module("vidatio").service("FileReaderService",
  ["$q", function ($q) {

    function Reader() {
      this.reader = new FileReader();
      this.deferred = undefined;
      this.progress = 0
    }

    Reader.prototype.readAsDataUrl = function (file) {

      // maybe there's a scope apply necessary here
      this.deferred = $q.defer();
      this.progress = 0;

      this.reader.onload = function () {
        this.deferred.resolve(this.reader.result);
      }.bind(this);

      this.reader.onerror = function () {
        this.deferred.reject(this.reader.result);
      }.bind(this);

      this.reader.onprogress = function (event) {
        this.progress = event.loaded / event.total;
      }.bind(this);

      this.reader.readAsText(file);
      return this.deferred.promise;
    };

    return new Reader;
  }]
);
