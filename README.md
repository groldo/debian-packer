# debian-packer

Packer debian image creation

Credentials are set to `<username>:<username>`.
The vmware image files are by default located at `<pwd>/output`.

```bash
packer build -var "output_directory=${HOME}/Virtual Machines.localized/debian12-latest" -var "username=packer" -force debian.pkr.hcl
```
