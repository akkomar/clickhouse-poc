## Setting up

Make credentials available via env var:
```
xport TF_VAR_gcp_credentials=$(cat /path/to/gcp/credentials.json)
```
Show a preview of resources to be created & verify credentials exist:
```
terraform plan
```
Create resources:
```
terraform apply
```

SSHing to vm:
```
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no `terraform output ip`
```

Cleaning up:
```
terraform destroy
```


## Install Clickhouse
```
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i terraform_inventory.sh provision.yml
```

