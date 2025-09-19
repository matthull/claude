---
type: guidance
status: current
category: rails
---

# CRUD Controller Patterns

## Model Controller Reference
**Always reference `App::Api::V2::VideoLinkAssetsController` as the canonical example for CRUD controllers.**

Look up this controller in the codebase when implementing new CRUD controllers to ensure consistency with established patterns.

## Key Patterns from VideoLinkAssetsController

### Structure Overview
- Inherits from `App::ApiController`
- Uses `before_action :set_asset` for show/update/destroy
- Minimal action implementations (often just empty methods)
- Renders jbuilder views for responses
- Uses `render_model_errors` for validation failures

### Action Patterns
- **show**: Empty method, relies on jbuilder view
- **create**: Initialize with params + current_account, save, render :show or errors
- **update**: Update with params, render :show or errors
- **destroy**: Destroy record, still render :show (returns deleted record)

### Protected Methods
- `set_[resource]`: Finds resource by ID
- `[resource]_params`: Strong parameters with require/permit

### Jbuilder Structure
- `show.json.jbuilder`: Wraps partial in resource name key
- Delegates to shared `_fields` partial in `api/[resources]/`
- Fields partial handles all attributes and associations

## Implementation Checklist
When creating a new CRUD controller:

1. **Look up VideoLinkAssetsController**: Open and reference the actual controller
2. **Copy the structure**: Match the action order and method signatures
3. **Adapt naming**: Replace `asset` with your resource name
4. **Check jbuilder paths**: Ensure partials follow the same structure
5. **Verify associations**: Include account merge in create if needed
6. **Test error handling**: Ensure render_model_errors is used consistently

## Common Variations
- Index actions may add pagination/filtering
- Some controllers skip certain actions
- Complex resources may override set_resource with additional includes

## Anti-patterns to Avoid
- Don't add business logic to controllers - use service objects
- Don't customize JSON responses in controller - use jbuilder
- Don't skip the set_resource pattern for standard actions
- Don't forget to merge current_account in create

Remember: When in doubt, open VideoLinkAssetsController and follow its patterns exactly.