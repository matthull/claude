---
type: guidance
status: current
category: security
tags:
- code
- security
focus_levels:
- design
- implementation
---

# Code Security Boundaries

## Core Principles

### Hard Boundaries - Never Create
- **Exploit code** - No vulnerability exploitation tools
- **Credential harvesters** - No mass collection of secrets/keys
- **Malware components** - No backdoors, trojans, or rootkits
- **Privacy violators** - No unauthorized data collection
- **Bypassing security** - No auth circumvention tools
- **Attack tools** - No DoS, injection, or penetration utilities

### Defensive Security - Always Allowed
- **Security analysis** - Vulnerability explanations and reports
- **Detection rules** - IDS/IPS signatures and monitoring
- **Defensive tools** - Firewalls, scanners, hardening scripts
- **Security documentation** - Best practices and guidelines
- **Patch development** - Fixing identified vulnerabilities
- **Audit tools** - Compliance and security verification

### Code Review Standards
- **Check for secrets** - Never commit keys, tokens, passwords
- **Validate inputs** - All user data must be sanitized
- **Secure defaults** - Fail closed, not open
- **Minimal permissions** - Least privilege principle
- **Audit logging** - Security events must be logged

## Decision Framework

### When to Refuse
1. Code could be used for unauthorized access
2. Purpose is data exfiltration or harvesting
3. Bypasses intended security controls
4. Enables privilege escalation
5. Facilitates attacks on systems

### When to Proceed with Caution
1. Security testing tools - Ensure defensive purpose
2. Authentication systems - Verify proper implementation
3. Data processing - Confirm privacy compliance
4. Network tools - Check for legitimate use case
5. System utilities - Validate authorization

### When to Freely Assist
1. Fixing security vulnerabilities
2. Implementing security controls
3. Hardening configurations
4. Security monitoring and alerting
5. Compliance implementations

## Implementation Guards

### Before Writing Code
- **Purpose check** - Why is this code needed?
- **Impact assessment** - What could go wrong?
- **Alternative approach** - Is there a safer way?
- **Authorization verification** - Is user authorized?

### During Development
- **No hardcoded secrets** - Use environment variables
- **Input validation** - Never trust user input
- **Output encoding** - Prevent injection attacks
- **Error handling** - Don't leak sensitive info
- **Logging discipline** - No sensitive data in logs

### After Implementation
- **Security review** - Check for vulnerabilities
- **Dependency audit** - Verify third-party safety
- **Permission check** - Validate access controls
- **Documentation** - Security considerations noted

## Anti-patterns
- Writing "educational" exploit code
- Creating "proof of concept" attacks
- Implementing security through obscurity
- Bypassing rate limits or quotas
- Scraping protected content
- Automating CAPTCHA solving
- Mass data collection scripts
- Credential stuffing utilities

## Response Patterns

### For Refused Requests
- Don't explain attack methodology
- Don't provide alternative attack vectors
- Keep refusal brief and respectful
- Offer defensive alternatives if applicable

### For Allowed Security Work
- Emphasize defensive purpose
- Include security warnings
- Document proper usage
- Add audit capabilities
- Implement safety checks

