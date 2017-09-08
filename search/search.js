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


/** Checks the URL of the currently web page and returns the keyword that should
 *  be used in the Elasticsearch record for that site. The reacchpna.org site
 *  should only be searching its own records: not all records in the index.
 *  Return value: {array}
 */
function checkCurrentSite(){
	var currentSiteURL = getURL();
	var recordSourceList = [];
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		//Nothing yet
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		recordSourceList.push("bsu-miles");
		recordSourceList.push("metadata_editor");
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
	return recordSourceList;	
}

/** Checks what keywords to seach on based on what site is hosting the page
 *  Return value: {array}
 */

function checkRequiredKeywords(){
	var currentSiteURL = getURL();
	var keywordsList = [];
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		//Nothing yet
		keywordsList.push("reacch");
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		keywordsList.push("IIA-1301792");
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
	return keywordsList;	
}

function getURL(){
	return document.URL;
}

/** Check what site this script is on, and ignore publications in search resutls for certain sites
 * @param {object} query
 */

function checkIgnorePublications(query){
	var currentSiteURL = getURL();
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		//Nothing yet
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		//nothing yet
        }else if(currentSiteURL.indexOf("northwestknowledge.net") > -1){
		ignorePublications(query);
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
}

/** Puts the publication ignoring part of the query on the query object
 *  @param {object} queryObject
 */
function ignorePublications(queryObject){
	queryObject.query.bool.must_not.push({match:{keyword:"publication"}});
	queryObject.query.bool.must_not.push({match_phrase_prefix:{title:"Publication"}});
}

/** Checks which site the script is on, and ignores collection level  
 *  @param {object} query
 */
function checkIgnoreCollections(query){
	var currentSiteURL = getURL();
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		//Nothing yet
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		//nothing yet
        }else if(currentSiteURL.indexOf("northwestknowledge.net") > -1){
		ignoreCollections(query);
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
}

/** Puts the collection ignoring part of the query on the query object
 *  @param {object} queryObject
 */
function ignoreCollections(queryObject){
	queryObject.query.bool.must_not.push({wildcard:{collection:"*"}});
}

/** Search and match all records for the respective sites.
 *
 */
function searchAll(requiredSource, emptySearchKey){
    var query = "";
    var requiredKeywords = checkRequiredKeywords();
    var queryObject = {
			size:sizeVal,
			from:fromVal,
			query: {
				 bool: {
			
					must_not: [],
					must: [
						{ 
							match_all: { }
						},
						{
							bool:{
								should:[]
							}
						}
					]
				}
			}
		};
	//If site is northwestknowledge.net, then ignore publications
	checkIgnorePublications(queryObject);

  	//Check if search results should ignore collection level records 
	checkIgnoreCollections(queryObject);

      requiredSource.forEach(function(source){
		console.log("Adding source!!");
        	queryObject.query.bool.must[1].bool.should.push({match:{record_source:source}});
      });

    requiredKeywords.forEach(function(item){
	console.log("Adding keyword!" + item);
	queryObject.query.bool.must[1].bool.should.push({match:{keywords:item}});
    });
      if((requiredSource.length > 0) || (requiredKeywords.length > 0))
	 queryObject.query.bool.must[1].bool["minimum_number_should_match"] = 1;

      console.log("Printing search object:");
	console.log(queryObject);


    //If no record sources specificed, search all sources
    query = JSON.stringify(queryObject);
  //Search Elasticsearch
  queryElasticsearch(query, emptySearchKey);

}

$(document).ready(function(){
  var recordSource = checkCurrentSite();
  var emptySearchKey = "";
  searchAll(recordSource, emptySearchKey);

});

function doSearch(key) {
  $("#searchResultContainer").html("");

  /*
  This query selects only records where collection is null,
  which screens out granules; matches the search key in all
  fields; and provides a scoring bonus to records for which
  the title includes the search key.
  */
  
  //Get keywords to ignore
  var requiredSources = checkCurrentSite();
  var requiredKeywords = checkRequiredKeywords();

  var quoteRegex = /["]/g;
  var query = "";
  var queryObject = {
		  size: sizeVal,
		  from: fromVal,
		  query: {
		      bool: {
			  
			  must_not: [],
			  must: [
				{
					bool:{
						should:[]
					}
				}
			  ]
		      }
    	    	  }
              };

  //Check if we are on northwestknowledge.net, and if so, modify query to ignore in search results.
  checkIgnorePublications(queryObject);

  //Check if search results should ignore collection level records 
  checkIgnoreCollections(queryObject);

  if(key == ""){
      searchAll(checkCurrentSite(), "");
  }else{
      //If query text from user has quotes in it, then run exact match query
      if(quoteRegex.test(key)){
	  key = key.replace(quoteRegex, "");
	  queryObject.query.bool.must.push({match_phrase_prefix:{title:key}});

      }
      /* If the user has not wrapped their query in double quotes, then search all 
       * attributes in the record, however, matches in the title are boosted higher
       * than matches in other attributes. 
       */ 
      else{
	    queryObject.query.bool.must.push({multi_match:{query: key,fields: ["title^50000000", "abstract", "contacts", "identifiers", "keywords", "mdXmlPath", "sbeast", "sbnorth", "sbsouth", "sbwest", "record_source", "uid"],operator:"and"}});

      }

      //Some keyword that must be matched is present and must be added to the JSON query.
      //queryObject.query.bool.must.push({match:[]});

      requiredSources.forEach(function(source){
		console.log("Adding source!!");
        	queryObject.query.bool.must[0].bool.should.push({match:{record_source:source}});
      });

    requiredKeywords.forEach(function(item){
	queryObject.query.bool.must[0].bool.should.push({match:{keywords:item}});
    });
      if((requiredSources.length > 0) || (requiredKeywords.length > 0))
	 queryObject.query.bool.must[0].bool["minimum_number_should_match"] = 1;

     console.log("Printing search object:");
	console.log(queryObject);
      query = JSON.stringify(queryObject);
      
      //Search Elasticsearch
      queryElasticsearch(query, key);
  }
}

/** Use constructed JSON to query Elasticseach system and display results
 *  @param {JSON} searchQuery
 *
 */
function queryElasticsearch(searchQuery, key){
  url = "https://nknportal-prod.nkn.uidaho.edu/_search/"
  $.post(url, searchQuery,
    function(data) {
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
