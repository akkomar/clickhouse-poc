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

## Install terraform-ansible dynamic inventory plugin
```
git clone https://github.com/mantl/terraform.py
pip install ./terraform.py
cp terraform.py/scripts/terraform_inventory.sh .
```

## Install Clickhouse
```
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i terraform_inventory.sh provision.yml
```

### Updating role
Clickhouse role is included as subtree, to update run:
```
git subtree pull --prefix roles/ansible-clickhouse git@github.com:AlexeySetevoi/ansible-clickhouse.git master --squash 
```




## Useful resources
* https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform
* https://alex.dzyoba.com/blog/terraform-ansible/
* http://chrisarges.net/2018/01/05/using-terraform-and-ansible.html
