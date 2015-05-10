angular.module('vidatio').service("DataTableService", function () {
    function DataTable() {
      this.dataset = [];
    }

    DataTable.prototype.setDataset = function (data) {

      // safely remove all items, keeps data binding alive
      this.dataset.splice(0, this.dataset.length);

      var rows = data.split("\n");
      for (var i = 0; i < rows.length; ++i) {
        this.dataset.push(rows[i].split(","));
      }
    };

    DataTable.prototype.getDataset = function () {
      return this.dataset;
    };

    return new DataTable;
  }
);
