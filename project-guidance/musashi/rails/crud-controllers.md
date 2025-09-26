---
type: guidance
status: current
category: rails
---

# CRUD Controller Patterns

## Model Controller Reference
**Always reference `App::Api::V2::VideoLinkAssetsController` as the canonical example when creating or modifying ANY controller.**

Look up this controller in the codebase when implementing new CRUD controllers to ensure consistency with established patterns.

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
- Don't do ActiveRecord queries without scoping to current_account

Remember: When in doubt, open VideoLinkAssetsController and follow its patterns.
