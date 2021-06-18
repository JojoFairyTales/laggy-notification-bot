#!/usr/bin/env bash

cat usernames \
    | xargs -I @ bash -c \
        "curl --silent --location --request \
         GET \"https://api.twitch.tv/helix/search/channels?query=@\" \
         --header \"client-id: ${CLIENT_ID}\" \
         --header \"Authorization: Bearer ${OAUTH}\" \
         | jq -r '.data[] \
         | select(.display_name==\"@\") \
         | select(.is_live==true) \
         | .display_name, .title \
         | gsub(\"[\\n\\\"]\"; \"\")' " \
    | while read name; do read title; \
        trunc_title=$(echo $title | cut -c -40); \
        echo "$name: $trunc_title" \
        && curl --silent --request POST "${DISCORD_WEBHOOK}" --header 'Content-type: application/json' \
            -d "{\"username\":\"laggybot\",\"avatar_url\":\"\",\"content\":\"$name is live: $trunc_title (<https://twitch.tv/$name>)\"}" \
        ; done
