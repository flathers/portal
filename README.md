# portal
NKN's Data Portal

For installation:

-Go into the ./install directory

-review and run the elasticinstall.sh to install elasticsearch

-edit ../.htaccess to list the correct path to the datastore

-edit nknPortalSrc.sh to list the correct path to the datastore

-review and run the config.sh to copy nknPortalSrc.sh into /etc/profile.d
 and create links here to the various config files

-note that if you edit nknPortal.sh after linking and re-run config.sh,
 whatever is in nknPortalSrc.sh will overwrite your changes.

 -all the config files for portal should now be linked here:
  -getUsername.conf contains database connection info access to the Drupal DB
  -htaccess contains the location of the datastore for Apache to access
  -nkn.conf contains variables for the DataONE scripts
  -nknPortal.sh contains the location of the datastore for shell access

 -the files in ../dataONE/cert are zero-length dummy files.  The dataONE certs
 should be kept secure and unreadable to general users.  To use the dataONE
 scripts, you must copy the proper cert files into the cert directories.  You
 should also make sure that the SYSMETA_RIGHTSHOLDER is set to an appropriate
 name.  The scripts are set to use the datastore path from nknPortal.sh.
