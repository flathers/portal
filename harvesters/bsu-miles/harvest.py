#!/usr/bin/python

import sys
from lxml import etree

remote_url = "http://scholarworks.boisestate.edu/do/oai/?verb=ListRecords&metadataPrefix=dcq&set=publication:miles_data"
xslt_file = "/datastore/util/harvesters/bsu-miles/oaiListRecords2geoportalDC.xslt"
output_path = "/datastore/harvested/bsu-miles/"

oai_xml = etree.parse(remote_url)
xslt = etree.parse(xslt_file)
transform = etree.XSLT(xslt)
t = transform(oai_xml, outputPath=etree.XSLT.strparam(output_path))