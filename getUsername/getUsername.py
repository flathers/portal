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

# This application takes a POSTed PHP session id (session_id) and
# configuration keyword (config_kw) and an optional request id (request_id)
# and returns the username of the user logged in on the Drupal session
# associated with that session id.  It uses the config_kw to get connection
# parameters for a Drupal SQL server, then connects to that database and runs
# a simple query, returning a JSON envelope containing the original session id,
# configuration keyword, request id, and either a username or an error code.

from flask import Flask, jsonify, request
import ConfigParser
import MySQLdb
import os
import warnings

app = Flask(__name__)
#app.config['DEBUG'] = True


@app.route('/', methods = ['POST'])
def application():
    #Config file is 'getUsername.conf' located in the current directory
    config_file = os.path.dirname(__file__) + '/getUsername.conf'

    #Make SQL warnings into exceptions so we can catch them
    warnings.filterwarnings('error', category=MySQLdb.Warning)

    #Initialize db_con so we can refer to it in the finally block
    db_con = None

    #Initialize the output data structure
    output = {
      'session_id': '',
      'config_kw':  '',
      'request_id': '',
      'username':   '',
      'version':    '',
      'error_id':   ''
    }

    try:
        #Get the POST variables and store them for output
        output['session_id'] = request.form['session_id']
        output['config_kw'] = request.form['config_kw']
        if 'request_id' in request.form:
            output['request_id'] = request.form['request_id']

        #Open the config file and get the SQL connection parameters
        #Grab the version parameter before removing it from the rest
        config = get_config(config_file)
        conn_param = dict(config.items(output['config_kw']))
        version = conn_param['version'];
        output['version'] = version;
        del conn_param['version'];

        #Define the SQL query, connect to the DB, and execute
        #Note that Drupal 7 and 8 have different database structures,
        #so we choose a query based upon the 'version' parameter from config
        query = "";
        if version == '8':
            query = ("SELECT name FROM users_field_data INNER JOIN sessions ON users_field_data.uid=sessions.uid WHERE sessions.sid=%s;")
        else:
            query = ("SELECT name FROM users INNER JOIN sessions ON users.uid=sessions.uid WHERE sessions.sid=%s;")
        db_con = MySQLdb.connect(**conn_param)
        cur = db_con.cursor()
        cur.execute(query, [output['session_id']])

        #If we got no rows back, then the session_id must not be valid,
        #otherwise the username should be the only thing returned
        rows = cur.fetchall()
        if not rows:
            output['error'] = 'invalid_session'
        else:
            output['username'] = rows[0][0]
        cur.close()

    except KeyError:
        output['error_id'] = 'post_variable_missing'
    except MySQLdb.Error:
        output['error'] = 'database_error'
    except Exception as e:
        output['error'] = 'other_error' #e.message
    finally:
        if db_con:
            db_con.close()
        return jsonify(output)



# The function for reading the config file
def get_config(config_file):
    """Provide user with a ConfigParser that has read the `config_file`
        Returns:
            (ConfigParser) Config parser with a section for each config
    """
    assert os.path.isfile(config_file), "Config file %s does not exist!" \
        % os.path.abspath(config_file)
    config = ConfigParser.ConfigParser()
    config.read(config_file)
    return config



if __name__ == '__main__':
    app.run()
