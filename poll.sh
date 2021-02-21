#!/usr/bin/env bash

cat usernames |\
    xargs -I @ bash -c \
    "curl --silent --location --request \
    GET \"https://api.twitch.tv/helix/search/channels?query=@\" \
    --header \"client-id: ${CLIENT_ID}\" \
    --header \"Authorization: Bearer ${OAUTH}\" \
    | jq -r '.data[] | select(.display_name==\"@\") | select(.is_live==true) | .display_name, .title'" |\
    while read name; do read title; curl --silent --header 'Content-type: application/json' \
        --request POST "${DISCORD_WEBHOOK}" \
        -d "{\"username\":\"laggybot\",\"avatar_url\":\"\",\"content\":\"$name is live: $title (<https://twitch.tv/$name>)\"}" \
        ; done
