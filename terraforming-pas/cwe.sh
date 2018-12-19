om -k curl --path /api/v0/staged/vm_extensions/router-internal-lb -x PUT -d \
   '{"name": "router-internal-lb", "cloud_properties": { "backend_service": {"name": "sm-ci-ilb-router-lb", "scheme": "INTERNAL"}, "tags": [ "sm-ci-ilb-vms", "sm-ci-ilb-router-lb" ] }}'
 om -k curl --path /api/v0/staged/vm_extensions/tcp-internal-lb -x PUT -d \
   '{"name": "tcp-internal-lb", "cloud_properties": { "backend_service": {"name": "sm-ci-ilb-tcp-lb", "scheme": "INTERNAL"}, "tags": [ "sm-ci-ilb-vms", "sm-ci-ilb-tcp-lb" ] }}'
 om -k curl --path /api/v0/staged/vm_extensions/ssh-internal-lb -x PUT -d \
   '{"name": "ssh-internal-lb", "cloud_properties": { "backend_service": {"name": "sm-ci-ilb-ssh-lb", "scheme": "INTERNAL"}, "tags": [ "sm-ci-ilb-vms", "sm-ci-ilb-ssh-lb" ] }}'
