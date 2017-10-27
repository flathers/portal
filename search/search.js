var fromVal = 0;
var sizeVal = 10;
var pageVal = 0;
var totalRecords = 0;
var totalPages = 0;
var next = 1;
var prev = -1;
var lastSearchText = "";
var minShouldMatch;
var searchRect;

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
//function checkRequiredKeywords(qureyObject){
function checkRequiredKeywords(){
	var currentSiteURL = getURL();
	var keywordsList = [];
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		//Nothing yet
		keywordsList.push("reacch");
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		keywordsList.push("IIA-1301792");
//		queryObject.query.bool.must[0].bool.should.push("IIA-1301792");
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
	return keywordsList;	
}

/** Check what site page is loaded on, then constructs query specifically for that page
 *  @params {object} queryObject, {string} searchType
 */

function constructQuery(queryObject, searchType){
	var currentSiteURL = getURL();

	var index = 0;
	if(searchType.indexOf("all") > -1){
		index = 1;
	}
	
	if(currentSiteURL.indexOf("reacchpna.org") > -1){
		queryObject.query.bool.must[index].bool.should.push({match:{record_source:"reacch"}},{match:{keyword:"reacch"}});
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		queryObject.query.bool.must[index].bool.should.push({match:{record_source:"metadata_editor"}})
		queryObject.query.bool.must[index].bool.should.push({match:{keyword:"IIA-1301792"}});
//		queryObject.query.bool.must[index].bool.should.minimum_should_match = 2;
		queryObject.query.bool.must[index].bool.should.push({match:{record_source:"bsu-miles"}});
	}
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
		ignorePublications(query);
	}else if(currentSiteURL.indexOf("idahoecosystems.org") > -1){
		//nothing yet
        }else if(currentSiteURL.indexOf("northwestknowledge.net") > -1){
		ignorePublications(query);
	}else{
		//If search should return all records regardless of source, then don't return keyword.
	}
}

/** Puts the publication ignoring part of the query on the query object. Need a couple permutations
 *  of the work "publication" because of a couple different versions used, and one misspelling.
 *  @param {object} queryObject
 */
function ignorePublications(queryObject){
	queryObject.query.bool.must_not.push({match:{keyword:"publication"}});
	queryObject.query.bool.must_not.push({match_phrase_prefix:{title:"Publication"}});
	queryObject.query.bool.must_not.push({match_phrase_prefix:{title:"Published"}});
	//There is one publication that has the word "publication" misspelled. 
	queryObject.query.bool.must_not.push({match_phrase_prefix:{title:"Publicatoin"}});
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

/** Adds to query a range section that checks if record has a query intersecting 
 * the map's user defined bounding box.
 * @params {object} queryObject, {string} east, {string} west, {string} north, {string} south
 */
function addCoordinateCheckIntersecting(queryObject, east, west, north, south){
	if(typeof queryObject === 'object'){
		queryObject.query.bool.must[0].bool.should.push({range:{sbeast:{lte:east}}});
		queryObject.query.bool.must[0].bool.should.push({range:{sbwest:{gte:west}}});
		queryObject.query.bool.must[0].bool.should.push({range:{sbnorth:{lte:north}}});
		queryObject.query.bool.must[0].bool.should.push({range:{sbsouth:{gte:south}}});
		
		//Make sure at least one of these ranges is matched
		queryObject.query.bool.must[0].bool.minimum_should_match = 1;
	}
}

/** Adds to query a range section that checks if record has a query inside 
 * the map's user defined bounding box.
 * @params {object} queryObject, {string} east, {string} west, {string} north, {string} south
 */
function addCoordinateCheckWithin(queryObject, east, west, north, south){
	if(typeof queryObject === 'object'){
		queryObject.query.bool.must.pop();
		queryObject.query.bool.must.push({range:{sbeast:{lte:east}}});
		queryObject.query.bool.must.push({range:{sbwest:{gte:west}}});
		queryObject.query.bool.must.push({range:{sbnorth:{lte:north}}});
		queryObject.query.bool.must.push({range:{sbsouth:{gte:south}}});
	}
}

/** Search and match all records for the respective sites.
 *  @params {array} requiredSource, {string} emtpySearchKey
 */
function searchAll(requiredSource, emptySearchKey){
    //Remove previous page's search results
    $("#searchResultContainer").html("");

    lastSearchText = emptySearchKey;
    let query = "";
    let queryObject = {
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
    
    //Adding specific query parameters to the query based on what site the page is loaded on.
    constructQuery(queryObject, "all");
    
    //If no record sources specificed, search all sources
    query = JSON.stringify(queryObject);
    //Search Elasticsearch

    queryElasticsearch(query, emptySearchKey);
}

function checkNestedProperty(obj, key){
	return key.split(".").every(function(x){
		if(typeof obj == "undefined" || obj === null || ! x in obj){
			return false;
		}
		obj = obj[x];
		return true;
	});
}

$(document).ready(function(){
  var emptySearchKey = "";
  searchAll(emptySearchKey);
});

function doSearch(key) {
  $("#searchResultContainer").html("");

  /*
  This query selects only records where collection is null,
  which screens out granules; matches the search key in all
  fields; and provides a scoring bonus to records for which
  the title includes the search key.
  */
  let quoteRegex = /["]/g;
  let query = "";
  let queryObject = {
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


  let spatialRelString="";
  if( searchRect ){
	var southWestCorner = searchRect.getBounds().getSouthWest();
	var northEastCorner = searchRect.getBounds().getNorthEast();
	var north = northEastCorner.lat();
	var south = southWestCorner.lat();
	var east = northEastCorner.lng();
	var west = southWestCorner.lng();

	//If search box has been defined, then add to query
	
	var searchType = $("input[name='bounding']:checked").val();

	//If "Within" check box is selected
	if(searchType.indexOf("esriSpatialRelOverlaps") > -1){
		addCoordinateCheckIntersecting(queryObject, east, west, north, south);  	
	}else if(searchType.indexOf("esriSpatialRelWithin") > -1){
		addCoordinateCheckWithin(queryObject, east, west, north, south);  	
	}	
  }
    
    //Check if we are on northwestknowledge.net, and if so, modify query to ignore in search results.
    checkIgnorePublications(queryObject);
    
    //Check if search results should ignore collection level records 
    checkIgnoreCollections(queryObject);
    
    //If query text from user has quotes in it, then run exact match query
    if(quoteRegex.test(key)){
	key = key.replace(quoteRegex, "");
	queryObject.query.bool.must.push({match_phrase_prefix:{title:key}});
    }else{
	/* If the user has not wrapped their query in double quotes, then search all                                                                                                       * attributes in the record, however, matches in the title are boosted higher                                                                                                      * than matches in other attributes.                                                                                                                                               */
	queryObject.query.bool.must.push({multi_match:{query: key,fields: ["title^50000000", "abstract", "contacts", "identifiers", "keywords", "mdXmlPath", "record_source", "uid"],operator:"and"}});
    }
    //Adding specific query parameters to the query based on what site the page is loaded on.
    constructQuery(queryObject, "");
    
    query = JSON.stringify(queryObject);
    
    //Search Elasticsearch
    queryElasticsearch(query, key);
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
	//console.log(item._source.mdXmlPath);
        $.get(baseUrl + item._source.mdXmlPath, function(data){ 
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

  if(key === "")
      searchAll(checkCurrentSite(), key);
  else
      doSearch(key);
}
