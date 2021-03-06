#!/bin/bash
tag=latest


daemonized() {
	docker run \
	    -d \
	    --name zabbix-app \
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
	    luchnck/zabbix-xxl-postgresql:$1 && echo container started successifully
};

interactive() {
	docker run \
            -ti \
            --name zabbix-app \
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
            luchnck/zabbix-xxl-postgresql:$1 \
	    /bin/bash
};

usage() {
	echo " usage is \'./start-srv-container TAG mode\'"
	echo 'TAG - docker image tag (default latest)'
	echo 'mode - i(interactive), d(daemonized - default)'
};


if [ -n $1 ]
	then
		tag=$1
fi

if docker ps -a | grep "zabbix-app"
	then 
		docker rm -f zabbix-app
		echo "container removed forcedly"
fi

if [ -n $2 ]
	then
		case "$2" in
		i)if ! interactive $tag
			then
			  usage
		  fi
		;;
		*)if ! daemonized $tag 
			then
			  usage
		  fi
		;;
		esac	
fi


