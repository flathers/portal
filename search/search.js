fromVal = 0;
sizeVal = 5;
pageVal = 0;
totalRecords = 0;
next = 1;
prev = -1;

$(document).ready(function(){ init(); });

function init() {
  $("#prevPage").attr('hidden', true);
  $("#nextPage").attr('hidden', true);

  $("#search").click(function() {
    $("#search").attr('disabled', true);
    searchKey = $("#searchText").val();
    fromVal = 0;
    $("#currentPage").html('Current Page: 1');
    doSearch(searchKey);
  });

  $("#searchText").change(function() { 
    $("#search").attr('disabled', false);
  });

  $("#searchText").keyup(function(e) {
    $("#search").attr('disabled', false);
    $("#firstRecordNum").val("1");
    var code = e.which;
    if (code==13) {
      e.preventDefault();
      $("#search").click();
    }
  });

  //Get the next result set
  $("#nextPage").click(function() {
    searchKey = $("#searchText").val();
    page(searchKey, next);
  });

  //Get the previous result set
  $("#prevPage").click(function() {
    searchKey = $("#searchText").val();
    page(searchKey, prev);
  });
}


function doSearch(key) {
  $("#searchResultContainer").html("");

  /*
  This query selects only records where collection is null,
  which screens out granules; matches the search key in all
  fields; and provides a scoring bonus to records for which
  the title includes the search key.
  */

  query = JSON.stringify({
    size: sizeVal,
    from: fromVal,
    query: {
      bool: {
        must_not: {
          exists: {
            field: "collection"
          }
        },
        must: {
          match: {
            _all: {
              query: key,
              operator: "and"
            }
          }
        },
        should: {
          match: {
            title: {
              query: key,
              operator: "and",
              boost: 20
            }
          }
        }
      }
    }
  });

  url = "/search/"
  $.post(url, query,
    function(data) {
      baseUrl = '/portal/renderMetadata/php/render.php?xml=';
      totalRecords = parseInt(data.hits.total);
      $("#totalRecords").html('Records Found: ' + totalRecords);
      $.each(data.hits.hits, function(i, item) {
        $.get(baseUrl + item._source.mdXmlPath, function(data){ 
          $("#searchResultContainer").append(data + '<hr>');
        });
      });
      page(key, 0);
    }
  );
}


function page(key, direction) {
  if (direction === next)
    pageVal += 1;
  else if (direction === prev)
    pageVal -= 1;

  if (pageVal <= 0) {
    pageVal = 0;
    $("#prevPage").attr('hidden', true);
  }
  else
    $("#prevPage").attr('hidden', false);

  if (pageVal >= Math.floor(totalRecords / sizeVal)) {
    pageVal = Math.floor(totalRecords / sizeVal);
    $("#nextPage").attr('hidden', true);
  }
  else
    $("#nextPage").attr('hidden', false);

  //If direction==0, this was a search, not a page turn
  //so all we need to do is check the next/previous visibility
  if (direction == 0)
    return;

  fromVal = sizeVal * pageVal;
  $("#currentPage").html('Current Page: ' + (pageVal+1));
  doSearch(key);
}
