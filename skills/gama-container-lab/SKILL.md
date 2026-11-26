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

## Firecracker works on `crusoe-cpu1` (verified 2026-11-26)

`crusoe-cpu1` **does** expose `/dev/kvm` (8 vCPU, 31 GB RAM) and already had the pieces:
`/opt/fc/release-v1.17.0-x86_64/firecracker-v1.17.0-x86_64` and `/opt/fc/vmlinux.bin`.

The missing part was a guest image. It is now built there and reproducible:

```bash
sudo bash /opt/gama-cell/guest/build_rootfs.sh          # debootstrap jammy + systemd
# or the microVM template used by gama_mvm (python3 inside, serial shell):
sudo debootstrap --variant=minbase --include=python3,iproute2,procps jammy /tmp/root \
  http://archive.ubuntu.com/ubuntu
# /sbin/init: mount proc/sys/dev, print "login: ", exec /bin/sh -i </dev/ttyS0 >/dev/ttyS0
sudo mkfs.ext4 -q -F -d /tmp/root /root/gama_mvm/template.ext4     # 1.2 GB
```

Measured on that host (1 vCPU / 256 MB, 2026-11-26, `sudo python3 /tmp/fc_snap.py`):

| Operation | Result |
|---|---|
| boot to a usable shell | **810 ms** |
| full snapshot (268 MB memory) | **3.3 s** |
| restore (load + resume) | **7.2 ms**, first command in the guest returns `42` |
| exec through the serial console | ~92 ms per command |

The serial console is the transport, so an exec costs ~92 ms; there is **no vsock** in this
template, and the old "vsock exec ~11 ms / 5.8 ms fork" figures are withdrawn.

`mandate`'s bridge uses exactly this pool:

```bash
sudo GAMA_MVM_DIR=/opt/gama_mvm /opt/gama_mvm/venv/bin/python3 \
  -m mandate.firecracker_bridge -- python3 /tmp/fake_mcp.py
```

Verified: JSON-RPC request → guest → response with `inside_vm: true`.

`gama-lab-fra` and `crusoe-smoke` have no `/dev/kvm`, so containers there are plain Docker.
k3s is **not** installed on `crusoe-cpu1` on purpose: the node already runs containerd and other
workloads, and what mandate needs is the microVM, not an orchestrator.

Older runtime numbers (retired lab VM, 2026-10-31) remain below as **historical** only:

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
