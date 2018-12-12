om -k curl --path /api/v0/staged/vm_extensions/router-internal-lb -x PUT -d \
  '{"name": "router-internal-lb", "cloud_properties": { "backend_service": {"name": "jordan-pas-router-lb", "scheme": "INTERNAL"}, "tags": [ "jordan-pas-vms", "jordan-pas-router-lb" ] }}'
om -k curl --path /api/v0/staged/vm_extensions/tcp-internal-lb -x PUT -d \
  '{"name": "tcp-internal-lb", "cloud_properties": { "backend_service": {"name": "jordan-pas-tcp-lb", "scheme": "INTERNAL"}, "tags": [ "jordan-pas-vms", "jordan-pas-tcp-lb" ] }}'
om -k curl --path /api/v0/staged/vm_extensions/ssh-internal-lb -x PUT -d \
  '{"name": "ssh-internal-lb", "cloud_properties": { "backend_service": {"name": "jordan-pas-ssh-lb", "scheme": "INTERNAL"}, "tags": [ "jordan-pas-vms", "jordan-pas-ssh-lb" ] }}'
