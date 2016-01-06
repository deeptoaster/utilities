#!/usr/bin/python
import errno
import getpass
import os
import paramiko
import string
import sys

def mkcd(sftp, name):
	try:
		sftp.mkdir(name)
	except IOError:
		pass
	sftp.chdir(name)

transport = paramiko.Transport('titanic.caltech.edu')
transport.connect(username = raw_input('Username: '), password = getpass.getpass())
sftp = paramiko.SFTPClient.from_transport(transport)
sftp.chdir('/data/files/movies')
for path, dirs, files in os.walk(sys.argv[1]):
	for name in files:
		title = string.capwords(os.path.splitext(name.replace('_', ' '))[0])
		movie = os.path.join(path, name)
		parent = title[0]
		if not parent.isalpha():
			parent = '#'
		mkcd(sftp, parent)
		mkcd(sftp, title)
		try:
			sftp.stat(name)
			print 'Skipping', title
		except IOError:
			try:
				print 'Uploading', title
				sftp.put(movie, name)
			except IOError:
				pass
		sftp.chdir('../..')
