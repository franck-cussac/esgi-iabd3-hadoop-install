import json
from cm_api.api_client import ApiResource
from cm_api.endpoints.types import ApiClusterTemplate
from cm_api.endpoints.cms import ClouderaManager

resource = ApiResource("4d92d0ab-2fa6-4d9d-bef5-dbf0f5dc29ab.priv.cloud.scaleway.com", 7180, "admin", "admin", version=12)
cluster = resource.get_cluster("Cluster 2")
template = cluster.export()
with open('/tmp/template.json', 'w') as outfile:
    json.dump(template.to_json_dict(), outfile, indent=4, sort_keys=True)
