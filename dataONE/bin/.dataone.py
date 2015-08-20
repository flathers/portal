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
# These will need to be filled in by a human.
#
# pid is a version 4 UUID.  These are initially generated arbitrarily; their
# value is unimportant when inserting data into the member node except that
# they must be unique and likely to remain that way.  If a file on DataONE
# needs to be updated, you will need to refer to its pid in order to obsolete
# it.
#
# package_pid is a version 4 UUID that identifies the entire collection.
#
#
# *** IMPORTANT ***
# *** IMPORTANT ***
# *** IMPORTANT ***
#
# The metadata record MUST be the FIRST item listed in the ds dictionary!
#
# Once you have identified which file is the metadata, you must cust and paste
# it into the first postition.  The insert.py script assumes that the first
# file in the list is the science metadata.  If it isn't, then the dataset
# will never be indexed by DataONE because it will use the wrong file as
# science metadata.
#


package_pid = '7135c38c-4a5a-4c2b-ba19-a1dcf106720e'

ds = [ { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp.xml',
    'format_id': 'FGDC-STD-001-1998',
    'pid': '3287128f-c93d-4ac4-8a63-16e686ac77fc'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.dbf',
    'format_id': 'application/octet-stream',
    'pid': '7f6c29af-1412-44cd-a76d-75f6f03c82cd'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.prj',
    'format_id': 'application/octet-stream',
    'pid': '58f2fa60-4e6e-4db9-b304-306a352b083e'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbn',
    'format_id': 'application/octet-stream',
    'pid': '22be35a1-a5df-4ac2-acc9-cfcc12341a2a'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbx',
    'format_id': 'application/octet-stream',
    'pid': '1383b79e-f291-4588-8405-f0d785d1c5a3'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp',
    'format_id': 'application/octet-stream',
    'pid': '81ba4a53-7e36-4750-abfd-6d24c301a427'},
  { 'file_name': 'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shx',
    'format_id': 'application/octet-stream',
    'pid': '3b8fa71c-70de-4876-80f3-6502bcfc8f05'}]
