# simple-vm-deploy (HTTP demo + Ansible deploy)

Minimal Go HTTP service packaged with Docker and deployed to a VM via Ansible and GitHub Actions.

## What’s inside
- **Go app** exposing `/` and `/healthz` on port `8080`
- **Dockerfile** building a tiny, distroless image
- **docker-compose.yml** to run the app on the VM
- **Ansible** playbooks to install Docker and deploy the stack
- **GitHub Actions** pipeline: build → push (GHCR) → deploy (Ansible)

## Prereqs
- VM reachable via SSH (IP, port, user). Example: `root@185.241.234.22 -p 12345`
- Add repo secret `VM_SSH_PRIVATE_KEY` (private key permitted on the VM)
- Optional: make the image public on GHCR (default) or add docker login on the VM


## Local build & run
```bash
docker build -t ghcr.io/fj-x/simple-vm-deploy:latest .
docker run -p 8080:8080 ghcr.io/fj-x/simple-vm-deploy:latest
curl http://localhost:8080
