#!/bin/bash
ACTION=$1
purple='\033[0;35m'
red='\033[0;31m'
off='\033[0m'

case $ACTION in
    setup)
        # Setup to run the apiserver
        printf "${purple}[*] Setting server up${off}\n"
	sudo apt-get install python python-dev
	sudo apt-get install python-pip
	sudo apt-get install git
	sudo pip install -r requirements.txt
	;;
    production)
	# Start production server
	printf "${purple}[*] Starting remote server for PRODUCTION${off}\n"
	nohup ./apiserver.py -x 0.0.0.0 -p 5000 &
	echo $! > server.pid
	;;
    debug)
	# Start local debug server
	# Use "ssh -X" to get Xforward and then "firefox 127.0.0.1:5000"
	printf "${purple}[*] Starting local server for DEBUG${off}\n"
	printf "${purple}Use 'ssh -X' to get Xforward and then 'firefox 127.0.0.1:5000'${off}\n"
	./apiserver.py -x 127.0.0.1 -p 5000
	;;
    stop)
	# Stop a production server
	printf "${purple}[*] Killing production server${off}\n"
	kill `cat server.pid`
	rm server.pid
esac

printf "${purple}[*] Done${off}\n"

