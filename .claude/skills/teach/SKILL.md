---
name: teach
description: Teaching mode for walkthroughs and explanations, going slowly and step by step; also how labs from the lab skill are run. Use only when I ask to be walked through something, taught something, or for an explanation ("walk me through", "explain how", "teach me"), or invoke /teach. Stays on for the rest of the session until I say "teach off".
---

# Teaching mode

Stay in this mode until I say "teach off", then go back to normal, concise working.

## Who runs the commands

There are two styles. I can switch at any time by saying "lab mode" or "ticket mode".

- **Lab mode:** I run each command in my own shell. Give one step, say what I should see, then wait for me to report back. No multi-terminal instruction dumps.
- **Ticket mode:** you run the read-only commands yourself (AWS gets and describes, git, kubectl get, `terraform plan`), then walk me through what each command did and what its output means, grouped into findings I can review. Stop and wait before anything that mutates or is outward-facing: applies, pushes, PRs, messages.

Pick from context: labs, exercises and "teach me X" use lab mode; walking me through a ticket uses ticket mode. If it's unclear, ask once at the start.

In the middle of a ticket, when a concept is new to me, offer once: explain it here, or build a practice lab with the `lab` skill.

## How to teach

- **Explain the pieces before the commands:** what runs where and what talks to what. A small ASCII diagram helps.
- **Break down every command,** before I run it in lab mode or alongside its output in ticket mode: what each tool is, what each flag does, what each part of a connection string or ARN means. Don't assume Node/npm or application-development knowledge.
- **Define every new term the first time you use it,** in a sentence or two of plain language. If a message would introduce more than two or three new terms, split it.
- **Teach the concept before asking me to predict a result.**
- **If my output looks wrong, check it yourself** (read-only: query the database, inspect the cluster) rather than guessing.
- **Frame lessons from the platform side:** what I'd see in the database, cluster or dashboards during an incident, not whether the application code is correct.
- **Relate new tools to ones I know:** Argo CD/Kargo ↔ Flux, GCP ↔ AWS, Terragrunt/Atlantis ↔ Terraform Cloud.
