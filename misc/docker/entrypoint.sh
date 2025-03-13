#!/bin/sh

ADDITIONAL_ARGS=""

# Add --debug argument if DEBUG is set to true
if [ "$DEBUG" = "true" ]; then
  ADDITIONAL_ARGS="--debug"
fi
# Construct the command based on the mode
if [ "$SPAMPD_SA_MODE" = "remote" ]; then
  ADDITIONAL_ARGS="--saclient  --sa-host=${SPAMPD_SACLIENT_HOST} --sa-port=${SPAMPD_SACLIENT_PORT} $ADDITIONAL_ARGS"
elif [ "$SPAMPD_SA_MODE" = "socket" ]; then
  ADDITIONAL_ARGS="--saclient --sa-socketpath=${SPAMPD_SACLIENT_SOCKETPATH} $ADDITIONAL_ARGS"
fi

if [ -n "$SPAMPC_SACLIENT_USERNAME" ]; then
  ADDITIONAL_ARGS="$ADDITIONAL_ARGS --sa-username=${SPAMPC_SACLIENT_USERNAME}"
fi

rsyslogd -n &

# Check if any arguments are passed to the script
if [ $# -gt 0 ]; then
  # Execute the passed arguments as command
  exec "$@"
else
  # Execute the default command
  exec "/usr/sbin/spampd" "--nodetach" "--logident=spampd" "--user=spampd" "--group=spampd" "--host=$SPAMPD_HOST" "--relayhost=$SPAMPD_RELAYHOST" "--sef" "--tagall" $ADDITIONAL_ARGS
fi