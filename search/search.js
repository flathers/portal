var fromVal = 0;
var sizeVal = 10;
var pageVal = 0;
var totalRecords = 0;
var totalPages = 0;
var next = 1;
var prev = -1;
var lastSearchText = "";

$(document).ready(function(){ init(); });

function init() {
  $("#prevPage").attr('hidden', true);
  $("#nextPage").attr('hidden', true);

  $("#search").click(function() {
    $("#search").attr('disabled', true);
    searchKey = $("#searchText").val();
    fromVal = 0;
  //  $("#currentPage").html('Current Page: 1');
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

  var quoteRegex = /["]/g;
  //If query text from user has quotes in it, then run exact match query
  if(quoteRegex.test(key)){
	key = key.replace(quoteRegex, "");
	console.log("Printing key: " + key);
	  var query = JSON.stringify({
	    size: sizeVal,
	    from: fromVal,
	    query: {
		 bool: {
			
			must_not: {
				wildcard:{
					collection: "*"
				}
			},
			must: { 
				match_phrase_prefix: {
					title: key,
                		}	
		  	}
		}
    	    }
          });

  }else{
	  var query = JSON.stringify({
	    size: sizeVal,
	    from: fromVal,
	    query: {
	 	bool: {
			
			must_not:{
				wildcard: {
					collection: "*"
				}
			},
			must:{ 

				multi_match: {
					query: key,
					//type: "best_fields",
					fields: ["title^50000000", "abstract", "contacts", "identifiers", "keywords", "mdXmlPath", "sbeast", "sbnorth", "sbsouth", "sbwest", "record_source", "uid"],
					//tie_breaker: 0.3
					operator:"and"
        			}
    	    		}
		}
	    }
          });
  }
  url = "https://nknportal-prod.nkn.uidaho.edu/_search/"
  $.post(url, query,
    function(data) {
	console.log("Printing data: ");
	console.log(data);
      baseUrl = 'https://nknportal-prod.nkn.uidaho.edu/portal/renderMetadata/php/render.php?xml=';
      totalRecords = parseInt(data.hits.total);
      if(totalRecords == 0)
      	totalRecords++;

      totalPages = Math.ceil(totalRecords / sizeVal);
      if(lastSearchText != key)
      	pageVal = 0;

      $("#totalRecords").html('Records Found: ' + totalRecords + ' &nbsp; Showing Page ' + (pageVal+1) + ' of ' + totalPages);
      $.each(data.hits.hits, function(i, item) {
	console.log(item._source.mdXmlPath);
        $.get(baseUrl + item._source.mdXmlPath, function(data){ 
          //$("#searchResultContainer").append(data + '<hr>');
          $("#searchResultContainer").append(data);
        });
      });
      //Save the current search text to check against next query
      lastSearchText = key;

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
//  $("#currentPage").html('Current Page: ' + (pageVal+1) + ' of ' + totalPages);
  doSearch(key);
}
