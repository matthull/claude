---
type: guidance
status: current
category: elasticsearch
tags:
- elasticsearch
- troubleshooting
- musashi
- backend
focus_levels:
- implementation
---

# Musashi Elasticsearch Fielddata Fix

## Error Pattern
```
Text fields are not optimised for operations that require per-document field data
like aggregations and sorting. Set fielddata=true on [FIELD_NAME]
```

## Fix Command
Enable fielddata directly on ES index without modifying models:

```bash
docker exec musashi-elasticsearch-1 curl -X PUT \
  "localhost:9200/INDEX_NAME/_mapping" \
  -H 'Content-Type: application/json' \
  -d'{
    "properties": {
      "FIELD_NAME": {
        "type": "text",
        "fielddata": true,
        "analyzer": "standard"
      }
    }
  }'
```

## Get Index Name
From Musashi Rails logs:
```bash
docker logs musashi-web-1 --tail 500 | grep "Text fields are not optimised"
```

Look for `"index":"INDEX_NAME"` in the 400 error response.

Example: `recipients_development_20251030151724758`

## Models with Aggregation Fields

### Recipient
- `company_name`
- `size_group`
- `seniority`
- `volunteer_activities`
- `tags`

### SurveyResponse
- `size_group`
- `seniority`
- `tags`

### CustomerSpotlight
- `size_group`

### RenderableTestimonial
- `size_group`

### WebLinkRecipient
- `company_name`

### Survey
- `state`

## Bulk Fix Script
```bash
# Get index name from error, then:
for field in seniority company_name volunteer_activities tags; do
  docker exec musashi-elasticsearch-1 curl -s -X PUT \
    "localhost:9200/INDEX_NAME/_mapping" \
    -H 'Content-Type: application/json' \
    -d"{\"properties\":{\"$field\":{\"type\":\"text\",\"fielddata\":true,\"analyzer\":\"standard\"}}}"
done
```

## Notes
- Don't modify model files - use runtime ES fix
- Some fields may already be keyword type - skip those
- Fielddata enabled fields use more memory
- After fix, no restart needed
