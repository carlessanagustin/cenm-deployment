#!/usr/bin/env bash
[ "${DEBUG}" == 'true' ] && set -v
export INITIAL_USER_NAME=admin
export INITIAL_USER_PASSWORD=p4ssWord

{{ if eq .Values.bashDebug true }}
set -x
{{ end }}


#
# main run
#
if [ -f bin/accounts-application.jar ]
then
    echo
    echo "CENM: starting CENM Auth service ..."
    echo
    java -jar bin/accounts-application.jar --config-file authservice.conf --initial-user-name ${INITIAL_USER_NAME} --initial-user-password ${INITIAL_USER_PASSWORD} --keep-running --verbose
    EXIT_CODE=${?}
else
    echo "Missing Auth service jar file."
    EXIT_CODE=110
fi

if [ "${EXIT_CODE}" -ne "0" ]
then
    HOW_LONG={{ .Values.sleepTimeAfterError }}
    echo
    echo "Auth service failed - exit code: ${EXIT_CODE} (error)"
    echo
    echo "Going to sleep for the requested {{ .Values.sleepTimeAfterError }} seconds to let you log in and investigate."
    sleep {{ .Values.sleepTimeAfterError }}
    echo
fi

echo