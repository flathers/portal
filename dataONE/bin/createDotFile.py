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


# createDotFile.py writes a .dataone.py file, given a directory as an
# argument.  It writes out a license and a bit of documentation, then
# appends a list of dictionaries that contain the attributes of the
# files to be inserted into the DataONE member node.  The format_id
# attribute is not populated because it's tricky to guess what kind
# of file it is.


# Stdlib.
import os
import pprint
import sys
import uuid

def main():
  # top will be the top matter of the dotfile that we write out
  top = '''#!/usr/bin/env python
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



'''

  base_path = sys.argv[1]
  # generate the dictionaries
  ds = [{'pid': format(uuid.uuid4()), 'file_name': f, 'format_id': ''} for f in os.listdir(base_path)]

  #write out the .dataone.py file
  with open(base_path + '/' + '.dataone.py', 'w') as fout:
    fout.write(top)
    fout.write('ds = ')
    pprint.pprint(ds, indent=2, stream=fout)


if __name__ == '__main__':
  main()
