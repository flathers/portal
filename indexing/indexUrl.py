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

import json
import sys
from elasticsearch import Elasticsearch
from getJsonByURL import processFile

def index(url):
    jsonText = processFile(url)
    es = Elasticsearch([{'host': 'localhost', 'port': 9200}])
    print es.index(index='test_metadata', doc_type='metadata', body=json.loads(jsonText))

if __name__== "__main__":
    if len(sys.argv) == 2:
        url = sys.argv[1]
        index(url)
    else:
        print "usage: indexJson.py <metadata url>"
