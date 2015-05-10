angular.module('vidatio').service("DataTableService",
  (function () {
    function DataTable() {
      this.dataset = []
    }

    DataTable.prototype.setDataset = function (data) {
      this.dataset.splice(0, this.dataset.length);        // safely remove all items, keeps data binding alive
      var rows = data.split("\n");
      var i = 0;
      var lengthRows = rows.length;
      for (i; i < lengthRows; ++i) {
        this.dataset.push(rows[i].split(","));
      }
    }
    DataTable.prototype.getDataset = function () {
      return this.dataset;
    }
    return DataTable;
  })()
);