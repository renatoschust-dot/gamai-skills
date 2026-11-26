# Devcontainer

`setup.sh` runs on container start (`postStartCommand`). It is opt-in by design:

| Variable | Effect |
|---|---|
| `TS_AUTHKEY` | joins your tailnet; unset means tailscale stays logged out |
| `GAMA_NODE_SETUP_URL` | HTTPS URL of a node setup script; unset means nothing is fetched |
| `GAMA_NODE_SETUP_SHA256` | required with the URL; the download runs only if the hash matches |

Nothing is fetched over plain HTTP and nothing is executed without a hash you supplied.
An earlier version downloaded a script from a LAN address over HTTP and ran it as root on
every start; that had no integrity check and has been removed.
