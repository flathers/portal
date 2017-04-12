#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2017 Northwest Knowledge Network
#
# Licensed under the Creative Commons CC BY 4.0 License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://creativecommons.org/licenses/by/4.0/legalcode
#
# Software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import contextlib
import json
import os
import pprint
import requests
import sys
import urllib2
from lxml import etree


def processFile(url):
    with contextlib.closing(urllib2.urlopen(url)) as stream:
        tree = etree.parse(stream)
        standard = getStandard(tree)
        itemXpaths, listXpaths = getXpaths(standard)
        jsonText = jsonify(url, tree, itemXpaths, listXpaths)
        return jsonText

# Given an xmlTree containing metadata, detect and return the name of the
# metadata standard
def getStandard(xmlTree):
    testPaths = {
    'arc100': '/metadata/Esri/ArcGISFormat',
    'dc': '/rdf:RDF/rdf:Description/dc:identifier',
    'eml210': '/eml:eml/dataset/title',
    'fgdc': '/metadata/metainfo/metstdv',
    'iso19139': '/gmd:MD_Metadata/gmd:metadataStandardVersion/gco:CharacterString',
    'iso2': '/gmi:MI_Metadata/gmd:metadataStandardVersion/gco:CharacterString',
    'iso2DS': '/gmd:DS_Series/gmd:seriesMetadata/gmi:MI_Metadata/gmd:metadataStandardVersion/gco:CharacterString',
    }

    root = xmlTree.getroot()
    nsmap = root.nsmap

    #Some ISO 19139 has a null namespace instead of gmd
    if None in nsmap:
        nsmap['gmd'] = nsmap[None]
        nsmap.pop(None)

    for item in sorted(testPaths.iteritems()):
        node = []
        try:
            #print item[0]
            node = xmlTree.xpath(item[1], namespaces=nsmap)
            if node != []:
                break
        except Exception, e:
            #print 'exception: ', e
            continue

    return(item[0])


# Given an xmlTree containing metadata and item and list xpath expressions,
# reduce the metadata to a json representation for insertion into elastic
def jsonify(url, xmlTree, itemXpaths, listXpaths):
    root = xmlTree.getroot()
    kvp = {}
    #single items are easy; just get the node text (if any) and insert into the dict
    for key in itemXpaths:
        if key == 'mdXmlPath':
            kvp[key] = url
        elif key == 'source':
            kvp[key] = 'filesystemIndexer'
        else:
            node = root.find(itemXpaths[key], root.nsmap)
            if node is not None:
                if node.text is not None:
                    #This join/split trick is to remove interior whitespace
                    kvp[key] = ' '.join(node.text.split())

    #list items are more complex
    for key in listXpaths:
        for item in listXpaths[key]:
            #add the empty list to the dict
            if key not in kvp.keys():
                kvp[key] = []

            nodeList = root.findall(item, root.nsmap)

            for node in nodeList:
                if node is not None:
                    #if the node isn't a leaf (len > 1), then concatenate its leaves' text and add to list
                    #this is primarily for things like contact names in eml, which are split among nodes
                    if len(node) > 1:
                        text = ''
                        for n in node:
                            for element in n.iter():
                                if element.text is not None:
                                    text = text + element.text + ' '
                        if not text in kvp[key]:
                            kvp[key].append(' '.join(text.split()))

                    #if the node is a leaf, then add its contents to the list, treating commas as delimiters
                    else:
                        for node in nodeList:
                            if node.text is not None:
                                if not node.text in kvp[key]:
                                    sublist = ' '.join(node.text.split()).split(",")
                                    sublist = [i.strip() for i in sublist]
                                    kvp[key] = kvp[key] + sublist

    #pprint.pprint(kvp)
    return(json.dumps(kvp, sort_keys=True, indent=4))


# Based upon a metadata standard, return two sets of xpaths: the itemXpaths
# are for values that are stored at a single xpath location within the metadata,
# the listXpaths are for values that may come from multiple xpaths, like
# keywords.  mdXmlPath and source are just placeholders and will get populated
# later.  Anything that has a '.' for an xpath is something that didn't map
# properly -- '.' won't lead to anything getting populated in that value.
def getXpaths(standard):
    if standard == 'arc100':
        ##################################################
        # ArcGIS 10.0 Format Index Term XPath Expressions
        ##################################################
        itemXpaths = {'abstract': 'metadata/dataIdInfo/idAbs',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': 'metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/eastBL',
                      'sbnorth': 'metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/northBL',
                      'sbsouth': 'metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/southBL',
                      'sbwest': 'metadata/dataIdInfo/dataExt/geoEle/GeoBndBox/westBL',
                      'title': 'metadata/dataIdInfo/idCitation/resTitle',
                     }
        listXpaths = {'contact': ['metadata/dataIdInfo/idPoC/rpIndName',
                                  'metadata/mdContact/rpIndName'],
                                  'identifier': ['.'],
                      'keyword': ['metadata/dataIdInfo/searchKeys/keyword',
                                  'metadata/dataIdInfo/themeKeys/keyword']
                    }

    elif standard == 'dc':
        ###########################################
        # Dublin Core Index Term XPath Expressions
        ###########################################
        itemXpaths = {'abstract': 'rdf:Description/dc:description',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': '.',
                      'sbnorth': '.',
                      'sbsouth': '.',
                      'sbwest': '.',
                      'title': 'rdf:Description/dc:title',
                     }
        listXpaths = {'contact': ['rdf:Description/dc:creator'],
                      'identifier': ['rdf:Description/dc:identifier'],
                      'keyword': ['rdf:Description/dc:subject']
                    }

    elif standard == 'eml210':
        #########################################
        # EML 2.1.0 Index Term XPath Expressions
        #########################################
        itemXpaths = {'abstract': 'dataset/abstract/para',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': 'dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate',
                      'sbnorth': 'dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate',
                      'sbsouth': 'dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate',
                      'sbwest': 'dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate',
                      'title': 'dataset/title',
                     }
        listXpaths = {'contact': ['dataset/associatedParty/individualName',
                                  'dataset/contact/individualName'],
                      'identifier': ['idinfo/datsetid'],
                      'keyword': ['dataset/keywordSet/keyword']
                    }

    elif standard == 'fgdc':
        ##########################################
        # FGDC CSDGM Index Term XPath Expressions
        ##########################################
        itemXpaths = {'abstract': 'idinfo/descript/abstract',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': 'idinfo/spdom/bounding/eastbc',
                      'sbnorth': 'idinfo/spdom/bounding/northbc',
                      'sbsouth': 'idinfo/spdom/bounding/southbc',
                      'sbwest': 'idinfo/spdom/bounding/westbc',
                      'title': 'idinfo/citation/citeinfo/title',
                     }
        listXpaths = {'contact': ['idinfo/ptcontac/cntinfo/cntperp/cntper',
                                  'idinfo/foobar'],
                      'identifier': ['idinfo/datsetid'],
                      'keyword': ['idinfo/keywords/theme/themekey',
                                  'idinfo/keywords/place/placekey']
                    }

    elif standard == 'iso19139':
        #########################################
        # ISO 19139 Index Term XPath Expressions
        #########################################
        #fixme: the example metadata doesn't have any of the list items, will need to find xpaths for them
        itemXpaths = {'abstract': '/MD_Metadata/identificationInfo/MD_DataIdentification/abstract',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': '/MD_Metadata/identificationInfo/MD_DataIdentification/extent/EX_Extent/geographicElement/EX_GeographicBoundingBox/eastBoundLongitude/gco:Decimal',
                      'sbnorth': '/MD_Metadata/identificationInfo/MD_DataIdentification/extent/EX_Extent/geographicElement/EX_GeographicBoundingBox/northBoundLongitude/gco:Decimal',
                      'sbsouth': '/MD_Metadata/identificationInfo/MD_DataIdentification/extent/EX_Extent/geographicElement/EX_GeographicBoundingBox/southBoundLongitude/gco:Decimal',
                      'sbwest': '/MD_Metadata/identificationInfo/MD_DataIdentification/extent/EX_Extent/geographicElement/EX_GeographicBoundingBox/westBoundLongitude/gco:Decimal',
                      'title': '/MD_Metadata/identificationInfo/MD_DataIdentification/citation/CI_Citation/title/gco:CharacterString',
                     }
        listXpaths = {'contact': [''],
                      'identifier': [''],
                      'keyword': ['']
                    }

    elif standard == 'iso2':
        ###########################################
        # ISO 19115-2 Index Term XPath Expressions
        ###########################################
        itemXpaths = {'abstract': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal',
                      'sbnorth': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal',
                      'sbsouth': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal',
                      'sbwest': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal',
                      'title': 'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString',
                     }
        listXpaths = {'contact': ['gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString',
                                  'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString'],
                      'identifier': ['gmd:fileIdentifier/gco:CharacterString'],
                      'keyword': ['gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode',
                                  'gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString']
                    }

    elif standard == 'iso2DS':
        ################################################
        # ISO 19115-2 (DS) Index Term XPath Expressions
        ################################################
        itemXpaths = {'abstract': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString',
                      'mdXmlPath': '.',
                      'source': '.',
                      'sbeast': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal',
                      'sbnorth': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal',
                      'sbsouth': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal',
                      'sbwest': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal',
                      'title': 'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString',
                     }
        listXpaths = {'contact': ['gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString',
                                  'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString'],
                      'identifier': ['gmd:seriesMetadata/gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString'],
                      'keyword': ['gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode',
                                  'gmd:seriesMetadata/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString']
                    }
    return itemXpaths, listXpaths


if __name__== "__main__":
    if len(sys.argv) == 2:
        url = sys.argv[1]
        processFile(url)
    else:
        print "usage: index.py <metadata url>"
