---
type: guidance
status: current
category: rails
---

# Background Job Patterns

## Core Design Principles

### Idempotency
- Design jobs to be safely retryable
- Running a job multiple times should produce the same result
- Use unique job IDs or database constraints to prevent duplicates
- Check if work was already completed before processing
- Log but don't fail if the expected outcome already exists

### Atomicity
- Keep jobs focused on a single responsibility
- Break complex operations into multiple smaller jobs
- Use database transactions appropriately
- Consider what happens if job fails partway through
- Design for partial failure recovery

## Error Handling Strategies

### Retry Logic
- Configure appropriate retry intervals
- Use exponential backoff for transient failures
- Set maximum retry attempts based on job type
- Consider different retry strategies for different error types
- Dead letter failed jobs after max retries

### Error Classification
- Distinguish between recoverable and non-recoverable errors
- Don't retry jobs that will always fail (bad data, logic errors)
- Retry transient failures (network issues, timeouts)
- Alert on repeated failures
- Log enough context to debug failures

### Failure Recovery
- Design jobs to resume from point of failure when possible
- Store progress state for long-running jobs
- Implement circuit breakers for external service failures
- Provide manual retry mechanisms for admin intervention
- Clean up partial work on permanent failure

## Performance Optimization

### Job Scheduling
- Avoid scheduling all jobs at the same time
- Use job priorities appropriately
- Consider job queue congestion
- Schedule recurring jobs during off-peak hours
- Batch similar work when possible

### Resource Management
- Be mindful of memory usage in jobs
- Release resources explicitly when done
- Avoid loading large datasets into memory
- Use streaming/batching for large data processing
- Monitor job duration and resource consumption

### Queue Design
- Use separate queues for different job types
- Isolate critical jobs from bulk processing
- Set appropriate concurrency limits per queue
- Monitor queue depths and processing times
- Scale workers based on queue metrics

## Data Handling

### Parameter Passing
- Pass IDs instead of objects to jobs
- Reload data from database in job execution
- Handle cases where records no longer exist
- Validate data state before processing
- Keep job parameters small and serializable

### State Management
- Don't rely on in-memory state between retries
- Store progress in database for long-running jobs
- Use Redis for temporary state with expiration
- Clean up temporary data after job completion
- Handle state conflicts in concurrent jobs

## External Service Integration

### API Calls
- Implement timeouts for external requests
- Handle rate limiting gracefully
- Use circuit breakers for failing services
- Cache responses when appropriate
- Log external service interactions

### Webhook Processing
- Verify webhook authenticity
- Deduplicate webhook events
- Process webhooks asynchronously
- Store raw webhook data for debugging
- Implement webhook replay capability

## Monitoring and Observability

### Logging
- Log job start, completion, and failure
- Include relevant context and parameters
- Use structured logging for better searchability
- Log external service interactions
- Avoid logging sensitive data

### Metrics
- Track job execution time
- Monitor failure rates by job type
- Alert on queue depth thresholds
- Track retry attempts
- Monitor resource usage patterns

### Debugging
- Include job ID in all log entries
- Store failed job parameters for investigation
- Implement job history tracking
- Provide tools to inspect job state
- Enable detailed logging for troubleshooting

## Testing Strategies

### Unit Testing
- Test job logic independently
- Mock external service calls
- Test error handling paths
- Verify idempotency
- Test parameter validation

### Integration Testing
- Test job scheduling and execution
- Verify retry behavior
- Test failure scenarios
- Validate cleanup logic
- Test queue routing

## Common Patterns

### Batch Processing
- Process records in chunks
- Use find_each for large datasets
- Implement progress tracking
- Handle partial batch failures
- Provide batch status reporting

### Scheduled Jobs
- Use cron-like scheduling for recurring tasks
- Prevent overlapping job runs
- Handle missed scheduled runs
- Monitor scheduled job execution
- Implement schedule conflict detection

### Event-Driven Jobs
- Process events asynchronously
- Maintain event ordering when required
- Handle out-of-order events
- Implement event replay capability
- Track event processing status

## Anti-patterns to Avoid

- Jobs that modify their own schedule
- Infinite retry loops without backoff
- Jobs dependent on specific execution order without guarantees
- Storing large objects in job parameters
- Long-running jobs without progress tracking
- Synchronous external API calls without timeouts
- Missing error handling for external services
- Jobs that assume database state won't change
- Not testing job failure scenarios
- Coupling job logic tightly to job framework