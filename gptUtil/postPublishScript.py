#!/usr/bin/python

import shlex
from subprocess import Popen, PIPE
import shutil
import smtplib
import sys
import os

uuid = sys.argv[1]
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

if (exit_code == 0):
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: New data posted for publication

Hi, NKN data publishers.  A new dataset has been approved for publication
in the geoportal interface. 
"""
else:
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: New data posted for publication [virus]

Hi, NKN data publishers.  A new dataset has been posted for publication
in the geoportal interface, but the data were infected with a virus.
Please take a look.
"""


try:
   smtpObj = smtplib.SMTP('localhost')
   smtpObj.sendmail(sender, receivers, message)
   print "Successfully sent email"
except SMTPException:
   print "Error: unable to send email"

#
#If the files were infected, send a notification email
#

if (exit_code != 0):
  #A virus was found, stop processing

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
#If the files are clean, move them into production
#
if (exit_code == 0):
  if (os.path.isdir('dsPath')):
    shutil.move(dsPath, datastorePath + uuid)

