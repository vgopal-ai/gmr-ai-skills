# Security and authentication rules

1. Never request a password in chat.
2. Prefer official browser/device-code/SSO/MFA authentication.
3. Never commit secrets, PATs, refresh tokens, client secrets, or secret-bearing connection strings.
4. Prefer user-level configuration for personal credentials.
5. Reuse existing approved authentication whenever possible.
6. Treat authentication and authorization separately: a successful login does not prove access to a database, workspace, catalog, or Power BI workspace.
7. Validate permissions with read-only operations during setup.
8. Write capability may be detected, but no write operation should be used merely to prove setup.
9. Admin/elevated operations require explicit human approval.
10. Production access must never be silently added.
11. Inspect existing authenticated connections and discover accessible targets before requesting target names or URLs.
12. Ask only for target details that cannot be discovered or uniquely identified; never request passwords, PATs, client secrets, or MFA codes in chat.
13. Never embed team-specific workspaces, servers, databases, projects, or repositories in shared skill defaults.
