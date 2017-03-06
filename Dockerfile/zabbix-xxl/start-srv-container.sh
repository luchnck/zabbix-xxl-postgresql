#!/bin/bash

daemonized() {
	docker run \
	    -d \
	    --name zabbix \
	    -p 80:80 \
	    -p 10051:10051 \
	    -v /etc/localtime:/etc/localtime:ro \
	    --link zabbix-db:zabbix.db \
	    --env="XXL_api=false" \
	    --env="DB_engine=postgresql" \
	    --env="ZS_DBName=zabbix" \
	    --env="ZS_DBHost=zabbix.db" \
	    --env="ZS_DBUser=postgres" \
	    --env="ZS_DBPassword=postgres" \
	    --env="ZS_DBPort=5432" \
	    luchnck/zabbix-xxl-with-postgresql 
};

interactive() {
	docker run \
            -ti \
            --name zabbix \
            -p 80:80 \
            -p 10051:10051 \
            -v /etc/localtime:/etc/localtime:ro \
            --link zabbix-db:zabbix.db \
            --env="XXL_api=false" \
            --env="DB_engine=postgresql" \
            --env="ZS_DBName=zabbix" \
            --env="ZS_DBHost=zabbix.db" \
            --env="ZS_DBUser=postgres" \
            --env="ZS_DBPassword=postgres" \
            --env="ZS_DBPort=5432" \
            luchnck/zabbix-xxl-with-postgresql \
	    /bin/bash
};
 
if $(docker ps -a | grep "zabbix ")
	then 
		docker rm -f zabbix
		echo "container removed forcedly"
fi

if [ -n $1 ]
	then
		case $1 in
		i) interactive
		;;
		*) daemonized
		;;
		esac	
fi
