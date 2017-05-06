fromVal = 0;
sizeVal = 5;
totalRecords = 0;
next = 1;
prev = -1;

$(document).ready(function(){ init(); });

function init() {
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
  url = "/_search/"
  $.getJSON(url, {
      default_operator: "AND",
      from: fromVal,
      q: key,
      size: sizeVal,
      _source: "mdXmlPath"
    },
    function(data) {
      baseUrl = '/portal/renderMetadata/php/render.php?xml=';
      totalRecords = parseInt(data.hits.total);
      $("#totalRecords").html('Records Found: ' + totalRecords);
      $.each(data.hits.hits, function(i, item) {
        $.get(baseUrl + item._source.mdXmlPath, function(data){ 
          $("#searchResultContainer").append(data + '<hr>');
        });
      });
    }
  );
}

function page(key, direction) {
  newFromVal = fromVal;
  newFromVal += sizeVal * direction;

  if(newFromVal > totalRecords)
    newFromVal = fromVal;
  fromVal = newFromVal;

  if(fromVal + sizeVal >= totalRecords)
    $("#nextPage").attr('hidden', true);
  else
    $("#nextPage").attr('hidden', false);

  if(fromVal >= sizeVal)
    $("#prevPage").attr('hidden', false);

  if(fromVal <= 0) {
    fromVal = 0;
    $("#prevPage").attr('hidden', true);
  }
  $("#currentPage").html('Current Page: ' + ((fromVal/sizeVal)+1));
  doSearch(key);
//  $("#search").click();
}
