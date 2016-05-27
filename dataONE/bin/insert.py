#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2016 Northwest Knowledge Network
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

'''
:mod:`create_data_package`
==========================

:Synopsis:
  This is adapted from Roger Dahl's example on how to use the DataONE Client
  Library for Python. It shows how to:

  - Automatically create data packages from local objects.
  - Generate the system metadata for a local file.
  - Generate an access policy for public access.
  - Upload the local files to a Member Node as science Science Object.
  - Create the data packages on the Member Node.

:Author:
  DataONE (Dahl)
  NKN (Flathers)

:Created:
  2013-02-27

:Modified:
  2015-08-18

:Requires:
  - Python 2.6 or 2.7.
  - DataONE Common Library for Python (automatically installed as a dependency)
  - DataONE Client Library for Python (sudo pip install dataone.libclient)
  - A client side certificate that is trusted by the target Member Node.
    (stored in ../cert/sandbox or ../cert/production)
  - A Python client for MSSQL pymssql (sudo pip install pymssql)

:Operation:
  Data packages are created from files in the target directory.

  For each file, a system metadata file is generated, based on information
  from the file and from a set of fixed settings.

  Then, a package for all the files is generated. System metadata is generated
  for the package, and the package is uploaded to the Member Node.
'''

# Stdlib.
import codecs
import ConfigParser
import datetime
import hashlib
import imp
import logging
import os
import sys
import StringIO
import time

# 3rd party.
import pyxb
import pymssql

# D1.
import d1_common.types.generated.dataoneTypes as dataoneTypes
import d1_common.const
import d1_client.data_package
import d1_client.mnclient

sys.dont_write_bytecode = True

# From http://peter-hoffmann.com/2010/retry-decorator-python.html
# I've included this because sometimes the GMN times out during
# create_science_object_on_member_node().  No error appears in the GMN logs,
# and the timeout happens on different files each time.  So this doesn't
# fix the underlying problem, but it does retry the object, which usually
# succeeds the second time.

class Retry(object):
    default_exceptions = (Exception,)
    def __init__(self, tries, exceptions=None, delay=0):
        """
        Decorator for retrying a function if exception occurs

        tries -- num tries
        exceptions -- exceptions to catch
        delay -- wait between retries
        """
        self.tries = tries
        if exceptions is None:
            exceptions = Retry.default_exceptions
        self.exceptions =  exceptions
        self.delay = delay

    def __call__(self, f):
        def fn(*args, **kwargs):
            exception = None
            for _ in range(self.tries):
                try:
                    return f(*args, **kwargs)
                except d1_common.types.exceptions.IdentifierNotUnique as e:
                    print "An object with the identifier already exists.  Skipping object..."
                    return fn
                except self.exceptions, e:
                    print "~~~~~~~~~Retry, exception: "+str(e)
                    time.sleep(self.delay)
                    exception = e
            #if no success after tries, raise last exception
            raise exception
        return fn



# The function for reading the config file
def get_config(config_file=None):
    """Provide user with a ConfigParser that has read the `config_file`
        Returns:
            (ConfigParser) Config parser with three sections: 'Common',
            'Sandbox', and 'Production'
    """
    if config_file is None:
        config_file = \
            os.path.join(os.path.dirname(__file__), './nkn.conf')

    assert os.path.isfile(config_file), "Config file %s does not exist!" \
        % os.path.abspath(config_file)

    config = ConfigParser.ConfigParser()
    config.read(config_file)
    return config


# Configuration settings come from the configuration file (nkn.conf by default)
# and are documented there.  Settings commong to all configurations are stored
# in the Common section, and settings specific to either Sandbox or Production
# operation (mainly certificate paths and server locations) are stored in their
# respective sections.

configMode = 'Sandbox'
config = get_config('nkn.conf')
SCIENCE_OBJECTS_BASE_PATH = config.get('Common', 'SCIENCE_OBJECTS_BASE_PATH').strip('\'')
SYSMETA_FORMATID = config.get('Common', 'SYSMETA_FORMATID').strip('\'')
SYSMETA_RIGHTSHOLDER = config.get('Common', 'SYSMETA_RIGHTSHOLDER').strip('\'')
RESOURCE_MAP_FORMAT_ID = config.get('Common', 'RESOURCE_MAP_FORMAT_ID').strip('\'')
DATASET_CONF_FILE_NAME = config.get('Common', 'DATASET_CONF_FILE_NAME').strip('\'')
MN_BASE_URL = config.get(configMode, 'MN_BASE_URL').strip('\'')
URL_DATAONE_ROOT = config.get(configMode, 'URL_DATAONE_ROOT').strip('\'')
CERTIFICATE_FOR_CREATE = config.get(configMode, 'CERTIFICATE_FOR_CREATE').strip('\'')
CERTIFICATE_FOR_CREATE_KEY = config.get(configMode, 'CERTIFICATE_FOR_CREATE_KEY').strip('\'')


def main():
  logging.basicConfig()
  logging.getLogger('').setLevel(logging.DEBUG)
  print 'Started insert.py in ' + configMode + ' mode'

  # Open the dataset config file and get the list of files to add
  # The open uses the nonstandard imp.load_source call because Python
  # doesn't like filenames that start with dots, but we want our config
  # files to be dotfiles because so many utilities ignore them.
  base_path = sys.argv[1]
  ds_conf_file = os.path.abspath(base_path + '/' + DATASET_CONF_FILE_NAME)
  ds_conf = imp.load_source('', ds_conf_file)
  print 'Base data path: ' + base_path

  # Create a Member Node client that can be used for running commands against
  # a specific Member Node.
  client = d1_client.mnclient.MemberNodeClient(MN_BASE_URL,
    cert_path=CERTIFICATE_FOR_CREATE,
    key_path=CERTIFICATE_FOR_CREATE_KEY)

  # Make sure enough files exist in the science objects list)
  if len(ds_conf.ds) < 2:
    raise Exception('Each group must have at least 2 files')

  # Iterate over the object groups and create them and their resource maps
  # on the Member Node.
  pids = []
  for item in ds_conf.ds:
    file_path = base_path + '/' + item['file_path'] + '/' + item['file_name']
    pids.append(item['pid'])
    print '\n Adding file:'
    print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    print 'Time: {0}'.format(datetime.datetime.now())
    print 'File: {0}'.format(item['file_name'])
    print 'Path: {0}'.format(file_path)
    print 'Pid: {0}'.format(item['pid'])
    print 'formatID: {0}\n'.format(item['format_id'])
    try:
      create_science_object_on_member_node(client, file_path,
        item['pid'], item['format_id'])
    except d1_common.types.exceptions.IdentifierNotUnique as e:
      print "An object with the identifier already exists.  Skipping object..."
  #print pids
  create_package_on_member_node(client, ds_conf.package_pid, pids)

  print 'Objects created successfully'


# Create the object on the Member Node. The create() call takes an open
# file-like object for the Science Object. Since we already have the data in a
# string, we use StringIO. Another way would be to open the file again, with "f
# = open(filename, 'rb')", and then pass "f". The StringIO method is more
# efficient if the file fits in memory, as it already had to be read from disk
# once, for the MD5 checksum calculation.
@Retry(12)
def create_science_object_on_member_node(client, file_path, pid, formatID):
  sci_obj = open(file_path, 'rb').read()
  sys_meta = generate_system_metadata_for_science_object(pid, formatID, sci_obj)
  client.create(pid, StringIO.StringIO(sci_obj), sys_meta)

def create_package_on_member_node(client, package_pid, pids):
  print '\nPackage_PID: {0}\n'.format(package_pid)
  resource_map = create_resource_map_for_pids(package_pid, pids)
  sys_meta = generate_system_metadata_for_science_object(package_pid,
    RESOURCE_MAP_FORMAT_ID, resource_map)
  client.create(package_pid, StringIO.StringIO(resource_map), sys_meta)

def create_resource_map_for_pids(package_pid, pids):
  # Create a resource map generator that will generate resource maps that, by
  # default, use the DataONE production environment for resolving the object
  # URIs. To use the resource map generator in a test environment, pass the base
  # url to the root CN in that environment in the dataone_root parameter.
  resource_map_generator = d1_client.data_package.ResourceMapGenerator(URL_DATAONE_ROOT)
  return resource_map_generator.simple_generate_resource_map(package_pid,
                                                             pids[0], pids[1:])


# Create the System Metadata for the object that is to be uploaded. The System
# Metadata contains information about the object, such as its format, access
# control list and size.
def generate_system_metadata_for_science_object(pid, format_id, science_object):
  size = len(science_object)
  md5 = hashlib.md5(science_object).hexdigest()
  now = datetime.datetime.now()
  sys_meta = generate_sys_meta(pid, format_id, size, md5, now)
  return sys_meta


def generate_sys_meta(pid, format_id, size, md5, now):
  sys_meta = dataoneTypes.systemMetadata()
  sys_meta.identifier = pid
  sys_meta.formatId = format_id
  sys_meta.size = size
  sys_meta.rightsHolder = SYSMETA_RIGHTSHOLDER
  sys_meta.checksum = dataoneTypes.checksum(md5)
  sys_meta.checksum.algorithm = 'MD5'
  sys_meta.dateUploaded = now
  sys_meta.dateSysMetadataModified = now
  sys_meta.accessPolicy = generate_public_access_policy()
  sys_meta.replicationPolicy = dataoneTypes.replicationPolicy()
  sys_meta.replicationPolicy.replicationAllowed = 'true'
  sys_meta.replicationPolicy.numberReplicas = '3'
  return sys_meta


def generate_public_access_policy():
  accessPolicy = dataoneTypes.accessPolicy()
  accessRule = dataoneTypes.AccessRule()
  accessRule.subject.append(d1_common.const.SUBJECT_PUBLIC)
  permission = dataoneTypes.Permission('read')
  accessRule.permission.append(permission)
  accessPolicy.append(accessRule)
  return accessPolicy


if __name__ == '__main__':
  main()
