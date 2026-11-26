---
name: gama-container-lab
description: Container lab across remote hosts — Docker on Crusoe and Vultr instances, driven over the HC protocol. Use when you need a real container host (not the local machine), a repeatable compose export, a k3s/kube test bed, or a measured runtime comparison (runc vs gVisor vs Firecracker). Triggers: "lab", "container lab", "docker on the node", "k3s", "gvisor", "firecracker", "microVM", "compose stack", "sandbox per task".
---

# Container lab — Crusoe and Vultr

The old single lab VM (`vmlab`, 10 vCPU / 33 GB / GTX 1660S) is **retired**. Containers now run on
the paid instances we already have, reached through the same fleet the agents use.

## Hosts (checked 2026-11-26)

| Node | Where | Docker | KVM / k3s |
|---|---|---|---|
| `crusoe-smoke` | Crusoe Brev, L40S | 27.3.1 | no |
| `crusoe-cpu1` | Crusoe Brev, CPU | 29.9.3 | no |
| `gama-lab-fra` | Vultr, Frankfurt | 29.9.3 | no |

`gama-lab-fra` was running the competition stack (`plebench-serve`, `plebench-egress`,
`data-hall-device-takeoff`) when this was written — that is what a "lab" looks like now: a real
Docker host per job, not one shared VM.

## Run something

```bash
# list what is running on a host
gama hc shell gama-lab-fra "docker ps --format '{{.Names}}'"

# one container, removed afterwards; no host network, no privileged
gama hc shell crusoe-cpu1 "docker run --rm --network none --cap-drop ALL \
  --security-opt no-new-privileges python:3.12-slim python -c 'print(1+1)'"

# a compose file you can keep (export from a running host, or write by hand)
gama hc shell gama-lab-fra "docker compose -f /srv/lab/compose.yml config -q && echo compose-ok"
```

**Rule:** a `docker run` container has no compose source. If you want the stack to be repeatable,
write `compose.yml` *first*; a file exported from `docker inspect` is a record, not a deployment —
`up` on it creates new containers with new names.

## k3s / Firecracker need a KVM host

Neither `gama-lab-fra` nor the Crusoe nodes expose `/dev/kvm`, so k3s-in-Docker and Firecracker
microVMs cannot run there. Those were measured on the retired lab VM (2026-10-31) and the numbers
below are **historical**:

| runtime | getpid | open+close | stat | fork+wait |
|---|---:|---:|---:|---:|
| bare | 92 ns | 1.3 µs | 0.5 µs | 60.9 µs |
| runc | 110 ns | 1.6 µs | 0.95 µs | 56.1 µs |
| gVisor | 751 ns | 5.5 µs | 3.2 µs | 820 µs |
| Firecracker | 54 ns | 1.4 µs | 0.36 µs | 82 µs |

Read that as "gVisor costs 4–13× on syscalls, Firecracker is close to native" — not as a claim about
today's hosts.

## What this does not prove

- Isolation on these hosts is plain Docker (namespaces + capabilities), not a microVM. Do not treat
  it as a security boundary for hostile code; use `gama-sandbox-srt` (no network, no secrets) for that.
- Ports, volumes and env differ per host. Nothing here ships a default address; the node name is the
  parameter.
- Disk is not guaranteed to persist between jobs on the cheaper instances. Treat containers as
  disposable and keep state outside them.
