#!/bin/bash
echo "Script started"
echo "please enter name of branch you want to clone ->"
read br
git clone --branch $br https://github.com/Sterlite-Technologies-Gurgaon-COE/stlnms.git
time(sudo ./stlnms/clean.pl && sudo ./stlnms/compile.pl -DskipTests -Dcheckstyle.skip && sudo ./stlnms/assemble.pl -DskipTests -Dcheckstyle.skip -p dir)
mkdir $PWD/database
sudo $PWD/stlnms/target/stlnms-27.2.0/bin/runjava -s
if [ ! "$(docker ps -a -q -f name=^nms_db)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=^nms_db)" ]; then
        # cleanup
        docker rm nms_db
    fi
    # run your container
    sudo docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres --name nms_db -v './database':'/var/lib/postgresql/data' postgres:13.9
    sudo $PWD/stlnms/target/stlnms-27.2.0/bin/install -dis
    sudo $PWD/stlnms/target/stlnms-27.2.0/bin/opennms start
fi
    
echo "Script completed
