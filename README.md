# Hosts

[![Run](https://github.com/Ryanjiena/Hosts/actions/workflows/run.yml/badge.svg)](https://github.com/Ryanjiena/Hosts/actions/workflows/run.yml) [![Visitors](https://komarev.com/ghpvc/?username=ryanjiena&color=brightgreen&style=flat&label=Visitors)](https://github.com/Ryanjiena/Ryanjiena)

<!-- hosts start -->

```
# Hosts From: [https://github.com/Ryanjiena/Hosts]
# Generated: 2023-09-03 20:43:54\n```

<!-- hosts end -->

## Usage

### Linux

```bash
mv /etc/hosts /etc/hosts.gc.bak

cp /etc/hosts.gc.bak /etc/hosts -f && curl -s https://hostsa.vercel.app/hosts | sudo tee -a /etc/hosts

# Clear or flush DNS cache
systemctl restart nscd.service
```

<details>
<summary>Run with systemd</summary>

```bash
#!/usr/bin/env bash
current_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
service="update_hosts"

mv /etc/hosts /etc/hosts.gc.bak

cat <<EOF > ${current_dir}/${service}.sh
#!/usr/bin/env bash
cp /etc/hosts.gc.bak /etc/hosts -f && curl -s https://hostsa.vercel.app/hosts | sudo tee -a /etc/hosts

EOF

chmod u+x ${current_dir}/${service}.sh

cat <<EOF > /etc/systemd/system/${service}.service
[Unit]
Description=Update hosts

[Service]
ExecStart=${current_dir}/${service}.sh

[Install]
WantedBy=default.target

EOF

systemctl start ${service}
systemctl enable ${service}
# systemctl stop ${service}
# systemctl disable ${service}
```

</details>

### Windows

1. Install [Chocolatey](https://chocolatey.org/install) / [Scoop](https://scoop.sh/)

2. Install [SwitchHosts](https://github.com/oldj/SwitchHosts)

   ```powershell
   choco install switchhosts
   scoop install switchhosts
   ```

3. Add new rules:

   - Title: `hostsa`
   - Type: `Remote`
   - URL: `https://hostsa.vercel.app/hosts`
   - Auto Refresh: `24 hours`

4. Clear or flush DNS cache: `ipconfig /flushdns`

## Thanks

- [521xueweihan/GitHub520](https://github.com/521xueweihan/GitHub520)

## License

Copyright (c) 2022 [Ryanjiena](https://github.com/Ryanjiena).

Licensed under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) license.
