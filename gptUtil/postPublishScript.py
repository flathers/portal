#!/usr/bin/python

import shlex
from subprocess import Popen, PIPE
import shutil
import smtplib
import sys
import os

uuid = sys.argv[1]
uuid = uuid.replace('{', '').replace('}', '').replace('[','').replace(']','')
basePath = '/preprod-datastore/uploads/'
dsPath = basePath + uuid + '/'
datastorePath = '/datastore/published/'



#
#Clamscan the dataset path
#
exit_code = 0
if (os.path.isdir('dsPath')):
  cmd = "/usr/bin/clamscan " + dsPath
  process = Popen(shlex.split(cmd), stdout=PIPE)
  process.communicate()
  exit_code = process.wait()
#print "~~~~~exit code " + str(exit_code)



#
#Send the notification email
#

sender = 'portal@northwestknowledge.net'
receivers = ['publish@northwestknowledge.net']

#if exit_code == 0, then clamscan returned that the files are clean
if (exit_code == 0):
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: New data approved for publication

Hi, NKN data publishers.  A new dataset has been approved for publication
in the geoportal interface.

Dataset path:
"""
  message = message + dsPath

#if exit_code != 0, then clamscan returned some error, possibly a virus
else:
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: New data approved for publication [virus]

Hi, NKN data publishers.  A new dataset has been posted for publication
in the geoportal interface, but the data were infected with a virus.
Please take a look.

https://northwestknowledge.net/geoportal/

Dataset path:
"""

message = message + dsPath

try:
   smtpObj = smtplib.SMTP('localhost')
   smtpObj.sendmail(sender, receivers, message)
   print "Successfully sent email"
except SMTPException:
   print "Error: unable to send email"



#
#If the files were infected, stop processing
#

if (exit_code != 0):
  exit();



#
#If the files are clean, move them into production
#
if (exit_code == 0):
  if (os.path.isdir(dsPath)):
    shutil.move(dsPath, datastorePath + uuid)
