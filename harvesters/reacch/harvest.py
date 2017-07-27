#!/usr/bin/python

import os
import sys
from lxml import etree

script_path = os.path.dirname(os.path.realpath(__file__))
base_output_path = os.environ['nknDatastoreRoot']

remote_url = "http://reacchapp2.nkn.uidaho.edu:8080/geoportal3/csw?request=getRecords&service=CSW&startPosition=1&maxRecords=2000&resultType=results&elementSetName=full&outputFormat=application/xml&outputschema=http://www.isotc211.org/2005/gmd"
xslt_file = script_path + "/geoportalCSWGetRecords2geoportalISO.xslt"
output_path = base_output_path + "/harvested/reacch/"

oai_xml = etree.parse(remote_url)
xslt = etree.parse(xslt_file)
transform = etree.XSLT(xslt)
t = transform(oai_xml, outputPath=etree.XSLT.strparam(output_path))
