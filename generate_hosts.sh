#!/usr/bin/env bash
# set -euxo pipefail

current_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
hosts_file="${current_dir}/hosts"
readme_file="${current_dir}/README.md"
hosts_readme_start="<\!-- hosts start -->"
hosts_readme_end="<\!-- hosts end -->"
# tmp_dir=$(mktemp -d /tmp/hosts.XXXXXX)
# log_file="${tmp_dir}/log"
user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5028.0 Safari/537.36"

DATE=$(TZ=UTC-8 date '+%Y-%m-%d %H:%M:%S')

domain_arr=(
    "alive.github.com"
    "live.github.com"
    "github.githubassets.com"
    "central.github.com"
    "desktop.githubusercontent.com"
    "assets-cdn.github.com"
    "camo.githubusercontent.com"
    "github.map.fastly.net"
    "github.global.ssl.fastly.net"
    "gist.github.com"
    "github.io"
    "github.com"
    "github.blog"
    "api.github.com"
    "raw.githubusercontent.com"
    "user-images.githubusercontent.com"
    "favicons.githubusercontent.com"
    "avatars5.githubusercontent.com"
    "avatars4.githubusercontent.com"
    "avatars3.githubusercontent.com"
    "avatars2.githubusercontent.com"
    "avatars1.githubusercontent.com"
    "avatars0.githubusercontent.com"
    "avatars.githubusercontent.com"
    "codeload.github.com"
    "github-cloud.s3.amazonaws.com"
    "github-com.s3.amazonaws.com"
    "github-production-release-asset-2e65be.s3.amazonaws.com"
    "github-production-user-asset-6210df.s3.amazonaws.com"
    "github-production-repository-file-5c1aeb.s3.amazonaws.com"
    "githubstatus.com"
    "github.community"
    "github.dev"
    "collector.github.com"
    "pipelines.actions.githubusercontent.com"
    "media.githubusercontent.com"
    "cloud.githubusercontent.com"
    "objects.githubusercontent.com"
    "vscode.dev"
    "plugins.jetbrains.com"
    "translate.googleapis.com"
    "deno.dev"
)

function insert_hosts() {
    # sed -e "/${hosts_readme_start}/,/${hosts_readme_end}/{//!d;}" -i ${readme_file}
    # sed -e "/${hosts_readme_start}/r ${hosts_file}" -i ${readme_file}
    local hosts=$(cat ${hosts_file} | sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g')
    sed -r '/'"${hosts_readme_start}"'/,/'"${hosts_readme_end}"'/c\'"${hosts_readme_start}"'\n\n```\n'"${hosts}"'\n```\n\n'"${hosts_readme_end}"'' -i ${readme_file}
}

function get_ip() {
    if [[ -f "${hosts_file}" ]]; then
        mv "${hosts_file}" "${hosts_file}.bak" -f
    fi

    echo -e "# Hosts From: [https://github.com/Ryanjiena/Hosts]\n# Generated: ${DATE}\n" >"${hosts_file}"

    for domain in "${domain_arr[@]}"; do
        local ipv4_arr=($(curl -sSkL -A "${user_agent}" "https://ipaddress.com/website/${domain}" | grep -Po "IPv4 Addresses.*?</li>" | grep -Po "<li>[0-9.]{11,}</li>" | awk "-F[<>]" '{print $3}'))
        for ipv4 in "${ipv4_arr[@]}"; do
            echo "${ipv4} ${domain}" >>"${hosts_file}"
        done

    done
}

get_ip
insert_hosts
