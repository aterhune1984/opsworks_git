#!/bin/bash

# chkconfig: 345 99 01
# description: some startup script

[ -f /etc/default/helloworld ] && . /etc/default/helloworld

case "$1" in
start)
   /home/ec2-user/pythondemo/bin/python /srv/pythondemo/helloworld.py &
   echo $!>/var/run/hello.pid
   ;;
stop)
   kill -9 `cat /var/run/hello.pid`
   rm /var/run/hello.pid
   ;;
restart)
   $0 stop
   $0 start
   ;;
status)
   if [ -e /var/run/hello.pid ]; then
      echo helloworld.sh is running, pid=`cat /var/run/hello.pid`
   else
      echo helloworld.sh is NOT running
      exit 1
   fi
   ;;
*)
   echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0
