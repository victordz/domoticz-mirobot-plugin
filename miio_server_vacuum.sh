#! /bin/sh
### BEGIN INIT INFO
# Author: mrin/schurgan
# Provides:          miio_server_vacuum
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: MIIO Server Vacuum
# Description:       This daemon will start MIIO Server Vacuum
### END INIT INFO

NAME="MIIO Server Vacuum"
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
SCRIPTNAME=/etc/init.d/miio_server_vacuum
PIDFILE=/var/run/miio_server_vacuum.pid

DAEMON_USER=root
DAEMON=/home/pi/domoticz/plugins/xiaomi-mirobot/miio_server_vacuum.py
DAEMON_ARGS="192.168.178.70 3656376f39463834595973774a613641"
DAEMON_ARGS="$DAEMON_ARGS --host 127.0.0.1 --port 33333"

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

. /lib/lsb/init-functions


do_start()
{
	# Return
	#   0 if daemon has been started
	#   1 if daemon was already running
	#   2 if daemon could not be started

	if pidofproc -p $PIDFILE "$DAEMON" > /dev/null 2>&1 ; then
	        return 1
	fi
}

case "$1" in
  start)
     log_daemon_msg "Starting $NAME"
     do_start
     RET_STATUS=$?
     case "$RET_STATUS" in
	1)
	   log_success_msg
           [ "$VERBOSE" != no ] && [ $RET_STATUS = 1 ] && log_warning_msg "Daemon was already running"
	;;
	*)
     	   start-stop-daemon --start  --background --oknodo --pidfile $PIDFILE --make-pidfile --chuid $DAEMON_USER --exec $DAEMON -- $DAEMON_ARGS
           log_end_msg $?
        ;;
     esac
     ;;
  stop)
     log_daemon_msg "Stopping $NAME"
     start-stop-daemon --stop --pidfile $PIDFILE --retry 10
     log_end_msg $?
   ;;
  force-reload|restart)
     $0 stop
     $0 start
   ;;
  status)
     status_of_proc -p $PIDFILE $DAEMON $NAME  && exit 0 || exit $?
   ;;
 *)
   echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|status}"
   exit 1
  ;;
esac
exit 0
