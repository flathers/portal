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
#
# This work is derived from a file that was distributed by the DataONE
# project which was licensed under the Apache License, Version 2.0.


# This is a sample .dataone.py file.  Each directory in the datastore that
# contains data that we replicate to DataONE should have one of these files.
# The file contains 3 Python dictionaries that describe attributes of the
# files within the directory.  These attributes are used when inserting the
# files into the DataONE member node.  For each dictionary, the first lines
# correspond, that is pid[0], files_in_group[0], and format_id[0] all refer
# to different attributes of the first file in the dataset.


# pid is a list of version 4 UUIDs, one for each file.  These are initially
# generated arbitrarily; their value is unimportant when inserting data into
# the member node except that they must be unique and likely to remain that
# way.  If a file on DataONE needs to be updated, you will need to refer to
# its pid in order to obsolete it.
pid = ['1db16857-55d0-4801-a926-825b1c96f5b1',
       '58b9c86e-d80a-4c51-b7e8-5df229035164',
       '32d21ebb-4e02-4b4d-a765-24e0d28e5d40',
       'ee0cdc6f-13a4-414e-b5a5-b0e6797b30d4',
       'c1fba4ea-04f2-44c3-a204-302a2c5248ec',
       '9cc018b9-eed5-47fb-b9cd-c304d6bdf604',
       '6d0871f1-32b4-4769-a5f0-c287d75097c3']


# files_in_group is a list of the name of each file in the dataset, excluding
# this file (.dataone.py).
files_in_group = ['BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.dbf',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.prj',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbn',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.sbx',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shp.xml',
                  'BT_CSC_NHD_1kmDataModel_Patches_Dissolve_Merge.shx']


# format_id is a list of the DataONE file format that describes each file.
# The list can be found at https://cn.dataone.org/cn/v1/formats
format_id = ['application/octet-stream',
             'application/octet-stream',
             'application/octet-stream',
             'application/octet-stream',
             'application/octet-stream',
             'FGDC-STD-001-1998',
             'application/octet-stream']
