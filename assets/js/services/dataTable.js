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

      // the dataset must have at least on cell
      if(this.dataset.length < 1){
        this.dataset.push([]);
      }
    };

    return new DataTable;
  }
);
