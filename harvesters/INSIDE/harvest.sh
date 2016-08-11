#/bin/bash
wget -N -r --no-parent -nH --cut-dirs=3 -e robots=off --reject index.html http://cloud.insideidaho.org/appsOutput/metadataWAF/xml/ -P /devdatastore/published/harvested/INSIDE/
