om -k curl --path /api/v0/staged/vm_extensions/router-internal-lb -x PUT -d \
   '{"name": "router-internal-lb", "cloud_properties": { "backend_service": {"name": "ch-sm-ilb-router-lb", "scheme": "INTERNAL"}, "tags": [ "ch-sm-ilb-vms", "ch-sm-ilb-router-lb" ] }}'
 om -k curl --path /api/v0/staged/vm_extensions/tcp-internal-lb -x PUT -d \
   '{"name": "tcp-internal-lb", "cloud_properties": { "backend_service": {"name": "ch-sm-ilb-tcp-lb", "scheme": "INTERNAL"}, "tags": [ "ch-sm-ilb-vms", "ch-sm-ilb-tcp-lb" ] }}'
 om -k curl --path /api/v0/staged/vm_extensions/ssh-internal-lb -x PUT -d \
   '{"name": "ssh-internal-lb", "cloud_properties": { "backend_service": {"name": "ch-sm-ilb-ssh-lb", "scheme": "INTERNAL"}, "tags": [ "ch-sm-ilb-vms", "ch-sm-ilb-ssh-lb" ] }}'
