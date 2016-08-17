#/bin/bash
wget -q -N -r --no-parent -nH --cut-dirs=3 -e robots=off --reject index.html http://cloud.insideidaho.org/appsOutput/metadataWAF/xml/ -P /datastore/harvested/inside/
