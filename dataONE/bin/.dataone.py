#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 20015 Northwest Knowledge Network
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


# This is a .dataone.py file.  Each directory in the datastore that contains
# data that we replicate to DataONE should have one of these files.  The file
# contains a list of Python dictionaries that describe attributes of the files
# within the directory.  These attributes are used when inserting the files
# into the DataONE member node.  Each dictionary contains a file_name,
# format_id, and pid for one file in the directory.  The file_name and pid
# attributes are usually generated automatically using the createDotFile.py
# utility.
#
# files_name is simply the name of the file of interest.
#
# format_id is the DataONE file format that describes each file.
# The list can be found at https://cn.dataone.org/cn/v1/formats
# These will likely need to be filled in by a human.
#
# pid is a version 4 UUID.  These are initially generated arbitrarily; their
# value is unimportant when inserting data into the member node except that
# they must be unique and likely to remain that way.  If a file on DataONE
# needs to be updated, you will need to refer to its pid in order to obsolete
# it.



ds = [ { 'file_name': '.dataone.py',
    'format_id': 'application/octet-stream',
    'pid': 'b1246998-b175-4f17-9a70-5aacd42d88e5'},
  { 'file_name': '.dataone.pyc',
    'format_id': 'application/octet-stream',
    'pid': '685be940-0f87-4df6-aa4f-3dfa67b93657'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.dbf',
    'format_id': 'application/octet-stream',
    'pid': 'ee963897-65ab-4694-99e8-105f4af7926d'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.prj',
    'format_id': 'application/octet-stream',
    'pid': '0a66c516-f89c-4121-b562-aef6b3518c0f'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbn',
    'format_id': 'application/octet-stream',
    'pid': '4d808f56-27c7-4cd1-bd28-4cd5938ddacb'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbx',
    'format_id': 'application/octet-stream',
    'pid': 'be0f01fe-0873-4622-8824-02cbd4be32bd'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp',
    'format_id': 'application/octet-stream',
    'pid': '2d669ae4-fed5-45f5-934d-bf793062fc80'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp.xml',
    'format_id': 'FGDC-STD-001-1998',
    'pid': '9504a8d7-a053-4e70-8957-ea6b2eb1bf97'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shx',
    'format_id': 'application/octet-stream',
    'pid': '13fef219-2528-44f8-b507-fd010fc60e0f'}]
