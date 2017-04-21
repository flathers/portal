#!/usr/bin/python

import os
import sys
from lxml import etree

script_path = os.path.dirname(os.path.realpath(__file__))
base_output_path = os.environ['nknDatastoreRoot']

remote_url = "http://scholarworks.boisestate.edu/do/oai/?verb=ListRecords&metadataPrefix=dcq&set=publication:miles_data"
xslt_file = script_path + "/harvesters/bsu-miles/oaiListRecords2geoportalDC.xslt"
output_path = base_output_path + "/harvested/bsu-miles/"

oai_xml = etree.parse(remote_url)
xslt = etree.parse(xslt_file)
transform = etree.XSLT(xslt)
t = transform(oai_xml, outputPath=etree.XSLT.strparam(output_path))
