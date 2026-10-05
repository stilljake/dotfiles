#!/usr/bin/env bash
# PreToolUse hook for Bash: block local Terraform state changes, ask before production or mutating infra commands.
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

# Perl regex match against the command (macOS grep lacks \b and -P).
has() { perl -e 'exit(($ARGV[1] =~ /$ARGV[0]/) ? 0 : 1)' -- "$1" "$cmd"; }

decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: $d, permissionDecisionReason: $r}}'
  exit 0
}

# Terraform changes go through a PR and Terraform Cloud, never the local CLI.
if has '\bterraform\b.*\b(apply|destroy|import|taint|untaint|force-unlock)\b' ||
   has '\bterraform\b.*\bstate\s+(rm|mv|push|replace-provider)\b'; then
  decide deny "Terraform changes go through a PR and Terraform Cloud, not the local CLI."
fi

if has '\.aws/credentials|\.terraform\.d/credentials|\.terraformrc'; then
  decide deny "Don't read cloud credentials."
fi

# Production: admin profile or production kube context, explicit or inherited.
if has 'production-admin|aws-prod-admin|--context[= ]+production\b|use-context\s+production\b' ||
   [ "${AWS_PROFILE:-}" = "production-admin" ]; then
  decide ask "Touches production with admin rights."
fi
if has '\b(kubectl|helm|flux)\b' && ! has '--context'; then
  ctx=$(kubectl config current-context 2>/dev/null || true)
  [[ "$ctx" == *production* ]] && decide ask "Current kube context is $ctx."
fi

# Mutating cluster and AWS commands.
if has '\bkubectl\b.*\b(apply|create|delete|edit|patch|replace|scale|rollout\s+(restart|undo|pause|resume)|drain|cordon|uncordon|taint|label|annotate|set|exec|cp|debug)\b' ||
   has '\bhelm\b.*\b(install|upgrade|uninstall|rollback|delete)\b' ||
   has '\bflux\b.*\b(suspend|resume|reconcile|delete|create)\b' ||
   has '\baws\b.*\s(create|delete|put|update|modify|terminate|attach|detach|start|stop|reboot|run|register|deregister|tag|untag|set|associate|disassociate|enable|disable|restore|reset|revoke|authorize|invoke|send|publish|cancel|import|copy|replace)-[a-z]' ||
   has '\baws\s+s3\s+(rm|mv|cp|sync|rb|mb)\b'; then
  decide ask "Mutating infrastructure command."
fi

exit 0
