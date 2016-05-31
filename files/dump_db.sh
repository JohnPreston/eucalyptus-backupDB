#!/usr/bin/env bash

############### MAN ###################

if [ "$#" -ne 2 ]; then
    echo "Missing Eucalyptus version value [ 3 , 4 ] and destination folder"
    exit 1
else

################

DEST_DIR=$2

################ - EUCA 3 DB version ONLY ###################

    if [ "$1" == '3' ]; then
        DBS=`psql -h /var/lib/eucalyptus/db/data -p 8777 -l | awk '{print $1}' | grep euca`
        for db in $DBS ; do pg_dump -c -o -h /var/lib/eucalyptus/db/data -p 8777 -U root $db > $DEST_DIR/$db-`date +%Y-%m-%d_%Hh%M`.sql ; done
    elif [ "$1" == '4' ]; then

############### - EUCA 4+ DB versions ONLY #################
        SCHEMAS=`psql -h /var/lib/eucalyptus/db/data/ -p 8777 eucalyptus_shared -c "select nspname from pg_catalog.pg_namespace;" | grep euca`
        for schema in $SCHEMAS ; do
            echo "Now doing $schema"
            pg_dump -c -o -h /var/lib/eucalyptus/db/data -p 8777 -U root eucalyptus_shared --schema=$schema | gzip > $DEST_DIR/EUCA-$schema-`date +%Y-%m-%d_%Hh%M`.sql.gz
        done
    fi
fi

# Author :John Mille
