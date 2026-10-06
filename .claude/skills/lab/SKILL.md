---
name: lab
description: Build a hands-on practice lab in ~/src/labs for a concept I'm learning (e.g. "dependency injection", "SQS retries"), with exercises compared to RA's code where possible. Use when I ask for a lab, practice exercises or hands-on practice on a topic, or invoke /lab. For an explanation or walkthrough without building anything, use teach.
argument-hint: "<topic>"
---

# Lab

Labs live in `~/src/labs`, one folder per topic. `~/src/labs/progress.md` says what I've done and what's next.

1. **Check what exists.** Read `progress.md`. If there's already a lab for this topic, offer to resume it instead.
2. **Find the RA connection.** If a work file in `~/src/ra/work/` is in play (picked up this session, or I name one), read it, then read the RA code where the concept shows up so the comparisons are accurate. If there's no RA connection, say so; the lab works on its own.
3. **Agree the outline.** Propose 4–6 exercises in a few lines: one concept each, each building on the last, plain version first and RA's libraries last (e.g. a hand-made fake before Moq). Wait for my OK.
4. **Write `~/src/labs/<topic-slug>/README.md`:**
   - Goal in one line, and the ticket that prompted it.
   - Terms: each new term in one or two plain sentences, compared to something I know (SQS, Flux, Terraform plan) where that helps.
   - Exercises: what to do, what I should see, and a "Compare with RA" line pointing at `<repo>/<path>:<line>` with one sentence on what's the same and what's different.
   Add starter files only where setup isn't the point; I write the code being learned.
5. **Run it** with the teach skill in lab mode.
6. **At the end of a session,** update `progress.md` (done, next step), then commit in `~/src/labs` with a subject-line message and push if there's a remote.

## Rules

- Never copy RA code, config, account IDs, hostnames or internal URLs into `~/src/labs`. Point at RA files by path; lab code is written from scratch.
- Keep labs local and free: no cloud spend unless I ask, and nothing that touches RA systems.
