#!/usr/bin/python

import shlex
from subprocess import Popen, PIPE
import shutil
import smtplib
import sys
import os

basePath = sys.argv[1]


#
#Clamscan the dataset path
#
exit_code = 0
if (os.path.isdir(basePath)):
  cmd = "/usr/bin/clamscan " + basePath
  process = Popen(shlex.split(cmd), stdout=PIPE)
  process.communicate()
  exit_code = process.wait()
#print >> sys.stderr, "~~~~~exit code " + str(exit_code)



#
#If exit_code != 0, then clamscan returned some error, possibly a virus,
#so quarantine the data and send the notification email
#

if (exit_code != 0):
  newPath = basePath.replace('/uploads/', '/quarantine/')
  shutil.move(basePath, newPath)

  sender = 'portal@northwestknowledge.net'
  receivers = ['portal@northwestknowledge.net']
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <portal@northwestknowledge.net>
Subject: Virus scan failed for uploaded data

Hi, NKN data publishers.  A new dataset has been uploaded in pre-production,
but the data failed the virus scan.  Please take a look.

Dataset path:
"""

  message = message + newPath

  try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message)
    #print "Successfully sent email"
  except SMTPException:
    #print "Error: unable to send email"
