Do not add Co-Authored-By lines to git commits.

## Git and PRs
- Commit messages: subject line only by default. Add a short body only for genuinely non-obvious context.
- PR descriptions: 1-2 plain sentences or a few bullets on what changed and why. No test plan, "prerequisites verified" or status-checklist sections, and don't tag teams or reviewers.
- Stage files by explicit path. Never `git add -A` or `git add .`; I often have unrelated work in progress in the repo.
- Local clones are often stale. `git fetch` and read `origin/main` before drawing conclusions about a repo, and branch from `origin/main`.

## Code
- Comments: one short inline comment saying what and why. Longer rationale belongs in the commit or PR.

## Answering questions
- Answer from evidence, not inference: for "which tool/version does X use", check lockfiles, pinned toolchains and the runtime environment, not names, labels or step titles. Say which source a claim comes from and what it doesn't cover.
- For consequential applies to shared infrastructure, tell me exactly what will change first and keep the blast radius small (targeted applies).
