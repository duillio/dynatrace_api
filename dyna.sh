#!/bin/bash
#variáveis
HOST='https://xxx99999.live.dynatrace.com'
TOKEN='Api-Token XX0c01.XXXXXXXXXXXXXXXXFJWAZLFC.NJJ2FSGXCB47PWHHZA4SKZWEPWTOXWS737XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
URILISTA='api/v2/problems?problemSelector=severityLevel%28%22AVAILABILITY%22%29,status(open)&pageSize=500'

echo "Gerando Lista de problems"
RESULT=$(curl -s -X GET "$HOST/$URILISTA" -H "authorization: $TOKEN" | jq --raw-output | grep '.problemId' | cut -d ':' -f2 | sed 's/"//g' | sed 's/,//g')


if [ -z "$RESULT" ]; then
        echo "Não encontrado problems de Low Load, saindo do script"
        exit 1
else

        for PROBELMITEM in $RESULT; do
                echo "Fechando Problem $PROBELMITEM"

                curl -sS -X POST "$HOST/api/v2/problems/$PROBELMITEM/close" -H "authorization: $TOKEN" -H 'content-type: application/json' -d '{"status": "CLOSED","message": "FECHADO"}'

        done

fi
