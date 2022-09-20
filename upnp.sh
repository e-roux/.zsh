#!/usr/bin/env bash

# Send UPnP message
#
# @param 1 - host:port/query (optional when UPNP_URL is set)
# @param 2 - service#action (optional when UPNP_ACTION is set)
# @param 3 - message arguments in XML format (optional)
upnp_send()
{
	# prefer arguments over presets
	local UPNP_URL=${1:-$UPNP_URL}
	local UPNP_ACTION=${2:-$UPNP_ACTION}
	local UPNP_ARGS=${3:-$UPNP_ARGS}

	# seperate host, port and query
	local HOST=${UPNP_URL%%/*}
	local PORT=${HOST#*:}
	HOST=${HOST%:*}
	local QUERY=${UPNP_URL#*/}

	if [ -z "$HOST" ] ||
		(( PORT == 0 )) ||
		[ -z "$QUERY" ]
	then
		echo 'error: invalid URL' >&2
		return 1
	fi

	# sepearte service and action
	local SERVICE=${UPNP_ACTION%%#*}
	local ACTION=${UPNP_ACTION##*#}

	if [ -z "$SERVICE" ] ||
		[ -z "$ACTION" ]
	then
		echo 'error: invalid service/action' >&2
		return 1
	fi

	# prepare SOAP message
	local CR=$'\r'
	local MESSAGE='<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
<s:Body>
<u:'${ACTION}' xmlns:u="'${SERVICE}'">'${UPNP_ARGS}'</u:'${ACTION}'>
</s:Body>
</s:Envelope>'

	exec 6<>/dev/tcp/"$HOST"/"$PORT" || {
		echo "error: can not connect to $HOST:$PORT" >&2
		return 1
	}

	cat <<EOF >&6
POST /$QUERY HTTP/1.0$CR
Host: $HOST:$PORT$CR
SOAPAction: "${SERVICE}#${ACTION}"$CR
Content-Type: text/xml; charset="utf-8"$CR
Content-Length: ${#MESSAGE}$CR
$CR
$MESSAGE
EOF

	cat <&6

	exec 6<&-
	exec 6>&-
}

if [ "${BASH_SOURCE[0]}" == "$0" ]
then
	upnp_send "$@"
fi
