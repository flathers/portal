#/usr/local/bin/bash

# Install the script that sets environment variables
/usr/bin/cp nknPortalSrc.sh /etc/profile.d/nknPortal.sh
/bin/ln -s /etc/profile.d/nknPortal.sh ./nknPortal.sh
/bin/ln -s ../.htaccess ./htaccess
/bin/ln -s ../getUsername/getUsername.conf .
/bin/ln -s ../dataONE/bin/nkn.conf .
