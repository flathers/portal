#!/usr/bin/python

import shlex
from subprocess import Popen, PIPE
import shutil
import smtplib
import sys

uuid = sys.argv[1]
basePath = '/preprod-datastore/uploads/'
dsPath = basePath + uuid + '/'
datastorePath = '/datastore/published/'



#
#Clamscan the dataset path
#

cmd = "/usr/bin/clamscan " + dsPath
process = Popen(shlex.split(cmd), stdout=PIPE)
process.communicate()
exit_code = process.wait()



#
#If the files were infected, send a notification email
#

if (exit_code != 0):
  sender = 'portal@northwestknowledge.net'
  receivers = ['publish@northwestknowledge.net']
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: Virus infection in approved data

Hi, NKN data publishers.  A new dataset has been approved for publication
in the geoportal interface, but the data were infected with a virus.  The
metadata record was published, but the data have been held back.  Please
take a look.
"""
  try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message)
    print "Successfully sent email"
  except SMTPException:
    print "Error: unable to send email"
  exit();



#
#If the files are clean, move the files into production
#
if (exit_code == 0):
  shutil.move(dsPath, datastorePath + uuid)
