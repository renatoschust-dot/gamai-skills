---
name: gama-vmlab-lab
description: Radi na GAMA vmlab (Lab VM) — pravi lokalni Docker daemon, gVisor, k3s, Firecracker mikro-VM sa KVM-om, gama-net bridge i GPU. Koristi kad treba izolovan sandbox po zadatku (mikro-VM), mjerenje overheada runtime-a, deploy pod-a na k3s, reproducibilni compose stack od 22 servisa, ili GPU posao na 1660S. Aktivira se na "vmlab", "lab VM", "firecracker", "gvisor", "microVM", "k3s", "compose stack", "sandbox po zadatku".
---

# GAMA vmlab — laboratorija (stanje 2026-10-31, izmjereno)

## Šta je vmlab
Lab VM: **10 vCPU / 33 GB RAM / disk 38.6G** · **GTX 1660 SUPER 6 GB** (`--gpus all` radi) · **pravi lokalni Docker daemon** (29.1.3, overlay2, cgroup v2, runtime `runc`+`runsc`+`nvidia`) · **k3s v1.36.5 single-node Ready** · **KVM radi** (`/dev/kvm`, vmx) → **Firecracker v1.17** · `/dev/net/tun` postoji.

## Dokazane brojke (ns/op, bench.c u $HOME/gama-vmlab-lab)
| runtime | getpid | open+close | stat | fork+wait |
|---|---|---|---|---|
| bare host | 92 | 1306 | 500 | 60.9 µs |
| runc | 110 | 1556 | 953 | 56.1 µs |
| **gVisor runsc** | **751 (8×)** | **5513 (4×)** | **3182 (6×)** | **820 µs (13.5×)** |
| **Firecracker** | **54** | **1416** | **358** | **82 µs** |

Firecracker: **pun boot 1.846 s**, **snapshot restore 2.286 ms** (`PUT /snapshot/load`, 2 vCPU/512 MB).
Zaključak: **Firecracker ≈ native** (overhead ~0–30%), **gVisor je 4–13× sporiji** → gVisor samo kad treba syscall filter, Firecracker kad treba izolacija + brzina.

## Recepti

### 1) Firecracker mikro-VM (boot)
```bash
# vmlinux + rootfs su u /opt/fc (rootfs.ext4 300M, vmlinux.bin, snap.bin/mem.bin)
cp /opt/fc/rootfs.ext4 /tmp/fclab/rootfs.ext4   # UVIJEK kopija, ne original
cat > /tmp/fclab/cfg.json <<'J'
{"boot-source":{"kernel_image_path":"/opt/fc/vmlinux.bin","boot_args":"console=ttyS0 reboot=k panic=1 pci=off root=/dev/vda rw init=/bench"},
 "drives":[{"drive_id":"rootfs","path_on_host":"/tmp/fclab/rootfs.ext4","is_root_device":true,"is_read_only":false}],
 "machine-config":{"vcpu_count":2,"mem_size_mib":512,"smt":false}}
J
/opt/fc/release-v1.17.0-x86_64/firecracker-v1.17.0-x86_64 --no-api --config-file /tmp/fclab/cfg.json
```
`init=/bench` = pokreni statični binary kao PID1 (iza njega `Kernel panic - Attempted to kill init` je NORMALNO, ne bug).
Za skriptu: ubaci `netup.sh` u rootfs (`mount -o loop rootfs.ext4 /mnt/fcr`, `chmod +x`, `umount`) i `init=/netup.sh`.

### 2) Snapshot restore (~2 ms)
```bash
firecracker --api-sock /tmp/fc.sock &
# PUT /snapshot/load {"snapshot_path":"/opt/fc/snap.bin","mem_backend":{"backend_path":"/opt/fc/mem.bin","backend_type":"File"},"resume_vm":true}
```
API govori HTTP/1.1 po unix socketu; `Connection: close` zna visjeti — čitaj po `Content-Length`.

### 3) Mikro-VM u gama-net (bez NAT-a)
```bash
ip tuntap add dev fctap0 mode tap; ip link set fctap0 master br-c99090ecf5f7; ip link set fctap0 up
# config: "network-interfaces":[{"iface_id":"eth0","host_dev_name":"fctap0","guest_mac":"06:00:ac:18:00:fa"}]
# u gostu: ip addr add <node-ip>/16 dev eth0; ip route add default via <node-ip>
```
Dokazano: gost → `http://<node-ip>:8080` (searxng) = **HTTP 200 za 4.8 ms**. Nema iptables/nft na hostu → **ne** očekuj NAT; koristi bridge.

### 4) gVisor vs runc
```bash
docker run --rm -v /path/bench:/bench:ro alpine:3.20 /bench            # runc
docker run --rm --runtime=runsc -v /path/bench:/bench:ro alpine:3.20 /bench
```

### 5) k3s
```bash
kubectl apply -f k3s-probe.yaml    # ns lab + pod + NodePort
curl -o /dev/null -w '%{http_code}' http://127.0.0.1:31683/
```
Dokazano: `lab/gama-probe` Running, **HTTP 200** preko NodePort-a i ClusterIP-a.

### 6) Compose stack (22 servisa)
`$HOME/gama-vmlab-lab/compose.yml` = verni export svih 22 kontejnera (`gen_compose.py` regeneriše iz `docker inspect`).
```bash
docker compose -f compose.yml config -q          # validacija
docker compose -f compose.yml --dry-run up -d   # plan bez diranja servisa
```
Plugin: `/usr/local/lib/docker/cli-plugins/docker-compose` (v2.40.3).

## Zamke (naučeno na svojoj koži)
- **BusyBox `date +%s%N` ne radi** → mjeri vrijeme iz `python3` (`time.time()`), inače dobiješ `elapsed_ms=0`.
- **`pkill -f firecracker` ubije i vlastiti shell** (pattern je u vlastitoj komandnoj liniji) → koristi `ps -eo pid,comm | awk '$2 ~ /firecracker/' | xargs kill`.
- `docker inspect -f '{{.Name}}'` vraća **`/ime`** (vodeći slash) → u compose ključeve ide `lstrip("/")`.
- `docker network inspect <net> -f '{{index .Options "com.docker.network.bridge.name"}}'` je prazan → bridge nađi kao `br-<id prvih 12>` iz `ip -o link`.
- Kontejneri su dizani `docker run`-om — nema compose izvora; `compose.yml` je **export**, pa `up` pravi nove kontejnere (`gama-vmlab-*`), ne adoptira postojeće.
- Disk je tijesan (bio 90%); nvidia/triton/torch/PySide6 wheelovi obrisani (6.8 GB) jer ih nijedan servis ne koristi (guard koristi ollama bge-m3 preko HTTP-a).

## k3s — izmjereno 31.10.2026 (namespace `lab`)
| eksperiment | dokaz |
|---|---|
| Deployment 2 replike + PVC (`local-path`) | 2/2 Running, PVC **Bound** |
| **Rolling update v1→v2** (`maxUnavailable: 0`) | **60/60 HTTP 200**, 0 padova |
| Self-heal (kill pod) | ReplicaSet digao zamjenu, servis 200 |
| **NetworkPolicy** (samo `lab` ns) | iz `default` ns **blokirano**, iz `lab` **200** |
| **GPU pod** (`runtimeClassName: nvidia`, `nvidia.com/gpu: 1`) | `nvidia-smi`: **GTX 1660 SUPER 6144 MiB**, driver 535.183.01 |
| **HPA** 2→6, target 30% | 2→4 za **~40 s**, →6 za **~60 s**, CPU **371%/30%**, cap „TooManyReplicas" |
| **CronJob** `*/1 * * * *` + PVC | Job **Complete**, `/backup/last.txt` = `2026-10-31T20:59:03Z` |
| **Redis + PVC perzistencija** | `set gama:test vmlab-2026` → **obrisan pod** → `get` = **vmlab-2026** |
| **Traefik Ingress** (`lab.gama.local`, NodePort 30080) | **v2** sa Host headerom, **404** bez |
| **Chaos** (svi podovi pod loadom) | oporavak **4 s**, **0 neuspjelih** zahtjeva |
| **ResourceQuota/LimitRange** (`labq`) | pod sa 800m **Forbidden** (`requests.cpu`, `pods`) — quota radi |

### Recepti (k3s)
```bash
# GPU: device plugin + runtimeclass (k3s sam prepozna nvidia-container-runtime)
kubectl apply -f nvidia-device-plugin.yml
kubectl -n kube-system patch ds nvidia-device-plugin-daemonset --type merge \
  -p '{"spec":{"template":{"spec":{"runtimeClassName":"nvidia"}}}}'
# bez ovog patcha plugin viče "No devices found" i capacity ostaje bez nvidia.com/gpu
kubectl get node -o jsonpath='{.items[0].status.capacity.nvidia\.com/gpu}'

# Ingress: k3s ovdje NEMA Traefik po defaultu (nema ingressclass) → HelmChart CRD
# apiVersion helm.cattle.io/v1 kind HelmChart spec.chart=traefik repo=https://traefik.github.io/charts
# valuesContent: service.type=NodePort, ports.web.nodePort=30080
```

### Zamke (k3s)
- **NetworkPolicy blokira i Ingress kontroler**: Traefik je u `kube-system`, pa policy mora dozvoliti i taj ns (`namespaceSelector` na `kubernetes.io/metadata.name: kube-system`) — inače Ingress daje **502 Bad Gateway**.
- HPA traži `resources.requests` na kontejneru; bez toga `cpu: <unknown>`. `kubectl get hpa` zna prikazati prazan CPU% i kad metrika radi → gledaj `.status.currentMetrics`.
- Kubernetes na ovom hostu **ne dijeli image cache sa Dockerom** — k3s vuče svoj (containerd), pa prvi pod s novim imageom čeka pull.
- Demo resursi: `lab` ns drži `labweb` (Deployment+NodePort 31080+Ingress), `labredis` (PVC), `lab-backup` (CronJob), `gama-probe`, `gpu-probe`; `labq` ns je quota demo.

## Sandbox pool za agente (gama_mvm) — 31.10.2026
`/opt/gama-vmlab-lab/gama_mvm.py` (na vmlabu i Contabu). Pool mikro-VM sa python3.12 **unutra** (ubijen python-build-standalone u rootfs), shell preko serijske konzole (stdin radi!).
- boot VM: **~2.33 s** (1 GB ext4 image), pool od 2 VM spreman **5.9 s**
- **exec latencija: 10.3 / 10.4 / 10.7 ms (min/med/max)** za 10 uzastopnih zadataka
- paralelno: 3 zadatka istovremeno; izolacija: `ls /root` u gostu = **prazno**; gost `uname -r` = 4.14.174
```python
import sys; sys.path.insert(0,'/opt/gama-vmlab-lab')
from gama_mvm import Pool
p = Pool(2)                    # 2 mikro-VM
print(p.run('python3 -c "print(6*7)"'))   # {'rc':0,'out':'42'}
p.close()
```
CLI: `python3 gama_mvm.py 'echo hi'` · env `MVM_N=3`.
Nema mreže u gostu (namjerno) → nema exfiltracije; dodaj TAP (recept gore) ako treba.

## Runtimeclassovi u k3s — šta je stvarno implementirano
| runtimeclass | stanje |
|---|---|
| **gvisor** | ✅ radi (pod `uname -r` = **4.19.0-gvisor**) |
| kata | ❌ samo stub — `containerd-shim-kata-v2` ne postoji, pod ostaje FailedCreatePodSandBox |
| wasmtime/wasmer/wasmedge/lunatic/spin/wws/slight | ❌ stub (nema shim binarija) |
Provjera: `ls /usr/bin/containerd-shim-*` → samo `runc-v2`, `runsc-v1`.

## GPU u k3s — dokle ide
- Device plugin (`runtimeClassName: nvidia` **na DaemonSetu**, inače „No devices found") → kubelet oglašava `nvidia.com/gpu: 1`; GPU pod radi (`nvidia-smi` vidi 1660S).
- **GPU LLM servis u k8s NIJE izvodljiv na ovom disku**: ollama image unpack traži ~2–4 GB i ruši node u DiskPressure; hostPath llama.cpp ne radi (Alpine/musl host + `libgomp`/CUDA libovi van kontejnera). Za GPU LLM ostani na hostu (`gama-llm.service`) ili proširi disk.

## Observability (Prometheus → k3s)
`/opt/gama-nodes/prometheus.yml` + token SA `kube-system/prometheus` (ClusterRole `prometheus-metrics`, nonResourceURLs `/metrics`, `/metrics/cadvisor`).
Jobovi `k3s-cadvisor` i `k3s-resources` → `https://<node-ip>:10250` (`insecure_skip_verify`), **health up**; `node` prebačen na `<node-ip>:9100` (node-exporter je na host netu, DNS iz gama-net ne radi).
Metrika radi: `container_cpu_usage_seconds_total{namespace="lab"}`.

## Backup (vmlab → Contabo)
`/opt/gama-vmlab-lab/backup_to_contabo.sh` → `$HOME/gama-backup/vmlab-YYYYMMDD/` na Contabu: `pg_dumpall` (gama, `-U postgres`), `pg_dump guacamole_db`, redis `SAVE` + tar, volumeni (gitea, n8n, qdrant, meili, uptime, grafana, fb), `manifest.txt` + `SHA256SUMS`.
Prvi run: **104 MB, 10 fajlova sa checksumom**, ~45 s.

## Flota (vmlab kao HC čvor)
`/opt/gama-vmlab-lab/fleet-vmlab.json` + `vmlab_hc.py`. HC protokol je **JSON po TCP** na :7100 (`{"cmd":"shell ...","tok":"<token>"}`; read komande bez tokena, akcije traže `tok`, ne `token`).
Dokazano **sa Contaba**: `who` i `shell hostname; uname -r; nproc` → `ubuntu / 5.15.0-1109-kvm / 10`.
Token na Contabu: `$HOME/.gama-vmlab-hc-token` (600).

## Nove zamke (31.10.)
- **Pun disk → kubelet disk-pressure taint ostaje zaglavljen** čak i kad se oslobodi mjesto; `kubectl taint ...-` ga vrati za minutu → **restart `k3s`** je jedini siguran fix. Kubelet evicta kad je < ~2 GB slobodno.
- **`sed -i` na bind-mountovanom configu** (prometheus.yml) mijenja inode → kontejner i dalje vidi stari fajl; koristi `cat > fajl` ili `docker restart`.
- Boot image za mikro-VM od 1 GB: rootfs je bio 100% pun; rješenje `mke2fs -d <tree>` (mke2fs je u `/sbin`, nije u PATH-u na Alpine hostu).
- `k3s` **ne dijeli** image cache sa Dockerom; `k3s crictl rmi --prune` oslobodi prostor.

## gama-mvm kao SERVIS za sve agente (31.10.2026)
- **systemd:** `gama-mvm.service` (Restart=always) → **HTTP `0.0.0.0:7110`**, token `/etc/gama-mvm-token` (600); pool `MVM_N=2`.
- **API:** `GET /health` (bez tokena), `GET /stats`, `POST /run` `{"cmd":"...","timeout":20}` sa headerom **`X-Token`**.
- **MCP:** `$HOME/gama_mvm/mvm_mcp.py` (stdio) — alati **`mvm_run`**, **`mvm_health`**; env `MVM_URL`, `MVM_TOKEN_FILE`.
- **Registrovano u opencode** na vmlabu (`$HOME/gama_mvm/mvm_mcp.py`, URL 127.0.0.1:7110) **i na Contabu** (`/opt/gama-vmlab-lab/mvm_mcp.py`, URL `http://<node-ip>:7110`, token `$HOME/.gama-mvm-token`); backup configa `opencode.jsonc.bak_mvm_*`.
- **Izmjereno:** MCP `mvm_run` **30.9 ms** lokalno, **30.8 ms** sa Contaba; gost `hostname` = `ubuntu-fc-uvm` (izolacija), rc/out se vraćaju.
- CLI test: `python3 $HOME/gama_mvm/mvm_server.py` (ili systemctl status gama-mvm), `curl -s 127.0.0.1:7110/health`.

## Restore drill (dokaz da backup radi)
- Postgres restore u scratch klaster: `rc=0`; jedina poruka `ERROR: role "postgres" already exists` (**bezopasno** — dumpall nosi role; za čist restore koristi `--no-role-passwords` ili prazan klaster).
- Volumen n8n: live `database.sqlite` sha256 `98e1c953dd18c2d1…` = **identičan** restauriranom; `pragma integrity_check` = **ok**, **160 tabela**.
- **Nalaz:** `gama` i `guacamole_db` baze imaju **0 tabela** (servisi nikad inicijalizovani) → pg dumpovi su legitimno ~1 KB; n8n/grafana imaju stvarne podatke (grafana 104 MB).

## Backup automatika (v2)
`gama-backup.service` + `gama-backup.timer` → **dnevno 03:00** (`Persistent=true`, random 5 min), retencija **7 dana**, ntfy na `127.0.0.1:8081/gama-backup`, log `/var/log/gama-backup.log`, stderr se više ne miješa u arhive (`pg_dump --clean --if-exists`).

## Disk (tvrda granica)
`vda` = 40 G, `vda1` = 39.9 G — **nema nealociranog prostora**; proširenje traži Vast panel/novi volumen. Stanje 31.10.: **84% (6.2 GB free)**, pool 2×~550 MB + template 547 MB.

## Migracija servisa Docker → k3s (searxng, 31.10.2026)
Prvi pravi servis preseljen: **searxng** iz Dockera u k3s, **bez promjene adrese za klijente**:
- `hostPort: 8092` na podu → i dalje `http://127.0.0.1:8092` (NodePort 30092, Ingress `searxng.gama.local:30080`).
- config (`settings.yml`, 204 B sa `secret_key`) → k8s **Secret** `lab/searxng-settings`; cache → `emptyDir` (regenerabilan).
- dokaz: **28 rezultata** na `/search?q=vmlab+firecracker`, 8092 → 200, NodePort 200, Ingress 200.
- Docker kontejner `gama-searxng` zaustavljen pa **uklonjen** (rollback = `docker run` isti env/volumeni; settings u Secretu).
- `compose.yml` regenerisan: sada **21 servis** (searxng je u k8s).
Zamka: hostPort zauzima port na nodu → ne može 2 replike na istom nodu; za HA koristi NodePort + Ingress bez hostPort-a.
