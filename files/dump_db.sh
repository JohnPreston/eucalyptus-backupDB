#!/usr/bin/env bash

############### MAN ###################

if ! [ "$#" -gt 1 ]; then
    echo: "Usage: eucalyptus_version dest_folder [--backend]"
    echo "Missing Eucalyptus version value [ 3 , 4 ] and dest folder"
    echo "Use --backend to dump the large backends too"
    exit 1
else

################

DEST_DIR=$2

################ - EUCA 3 DB version ONLY ###################

    if [ "$1" == '3' ]; then
        DBS=`sudo psql -h /var/lib/eucalyptus/db/data -p 8777 -l | awk '{print $1}' | grep euca`
        for db in $DBS ; do sudo pg_dump -c -o -h /var/lib/eucalyptus/db/data -p 8777 -U root $db > $DEST_DIR/$db-`date +%Y-%m-%d_%Hh%M`.sql ; done

############### - EUCA 4+ DB versions ONLY #################
    elif [ "$1" == '4' ]; then

        SCHEMAS=`sudo psql -h /var/lib/eucalyptus/db/data/ -p 8777 eucalyptus_shared -c "select nspname from pg_catalog.pg_namespace;" | grep euca | grep -v backend`
        for schema in $SCHEMAS ; do
            echo "Now doing $schema"
            sudo pg_dump -c -o -h /var/lib/eucalyptus/db/data -p 8777 -U root eucalyptus_shared --schema=$schema | gzip > $DEST_DIR/EUCA-$schema-`date +%Y-%m-%d_%Hh%M`.sql.gz
        done
	if [ "$#" -eq 3 ] && [ "$3" == "--backend" ]; then
	    echo "Dumping backends too"
            SCHEMAS=`sudo psql -h /var/lib/eucalyptus/db/data/ -p 8777 eucalyptus_shared -c "select nspname from pg_catalog.pg_namespace;" | grep euca | grep backend`
            for schema in $SCHEMAS ; do
		echo "Now doing $schema"
		sudo pg_dump -c -o -h /var/lib/eucalyptus/db/data -p 8777 -U root eucalyptus_shared --schema=$schema | gzip > $DEST_DIR/EUCA-$schema-`date +%Y-%m-%d_%Hh%M`.sql.gz
            done
	fi
    fi
fi

# Author :John Mille
