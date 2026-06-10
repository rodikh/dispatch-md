<p align="center">
  <img src="assets/wordmark.svg" alt="dispatch.md" height="72"/>
</p>

<p align="center">Your personal AI work assistant.</p>

---

dispatch.md turns an [Obsidian](https://obsidian.md) vault into a **work command center** driven by
[Claude](https://claude.com/claude-code). It tracks your tasks, projects, and meetings, and can
generate a **daily briefing** every morning by pulling from your calendar, email, Slack, GitHub,
and issue tracker.

Run `/setup` to configure this template with your personal information and connect your tools.

---

## 💬 See it in action

> A day with dispatch.md — morning briefing, a quick memory query, end-of-day roundup.

```
You:       Run a briefing

Dispatch:  Good morning! Here's your Tuesday, June 10 briefing.

           ⚡ Priorities Today
           1. PR #284 (auth refactor) has two approvals — ready to merge
           2. Reply to Sarah's DM about the API design question
           3. Prep for the 2pm architecture review

           📢 Standup
           Yesterday: shipped the rate-limiting middleware, unblocked the mobile team.
           Today: merge #284, finish the API spec draft.
           Blockers: none.

           📅 Calendar — moderate day
           10:00–10:30  Standup (team)
           14:00–15:00  Architecture Review  ← prep needed
           Best focus block: 11:00–13:30

           → Full briefing written to Daily/2026-06-10.md
```

```
You:       What did we decide about pagination in the API?

Dispatch:  From Notes/2026-05-28 API Design Session.md —
           Decision: cursor-based pagination (not offset). Rationale: the dataset
           grows unboundedly and offset pagination degrades at scale.
           Owner: you. Status: reflected in the draft spec, not yet in the PR.
```

```
You:       /eod

Dispatch:  Hey! Before I update the docs — did #284 actually get merged,
           or is it still waiting?

You:       Merged. Also had a good architecture review, we agreed on
           the event-sourcing approach for the notifications service.

Dispatch:  Got it — updating the docs now.
           ✅ EOD complete. Dashboard and today's note updated.
           Tomorrow's top priority: open the notifications service ticket
           and draft the initial schema.
```

---

## 🚀 Quick Start

### 1. Get the vault onto your machine
- Clone or download this folder somewhere convenient (e.g. `~/Documents/Obsidian/MyDispatch`).

### 2. Open it in Obsidian
- In Obsidian: *Open folder as vault* → pick this folder.
- On first open, click **Trust author & enable plugins** — all plugins (Tasks, Calendar, Kanban, the Claudian chat plugin, and more) are pre-bundled and load immediately. See [First-time Obsidian setup](#-first-time-obsidian-setup) for details.

### 3. Open it in Claude
- Open the Claudian plugin inside Obsidian — it's pre-bundled and ready to go. Claude automatically reads `CLAUDE.md` and becomes your Dispatch assistant.
- No Obsidian? Use the Claude Code CLI with this folder as the working directory.

### 4. Run the setup command
In your Claude session, type:
```
/setup
```
`/setup` interviews you and does all the wiring:
- ✍️ Fills in your **name, role, company, and email** across the vault
- 🔌 Helps you **connect your tools** (Calendar, Gmail, Slack, Drive, GitHub, Jira)
- ⏰ Optionally installs an **automated daily briefing** at a time you choose
- 🧹 Offers to clean up the sample content

That's it — you'll have a working personal assistant in a few minutes.

> Prefer to do it by hand? Open `CLAUDE.md` and replace every `{{PLACEHOLDER}}`, then read
> `Reference/Dispatch Setup.md`.

> **Don't have Obsidian?** No problem — the assistant runs entirely through Claude reading this folder. See [Using it without Obsidian](#-using-it-without-obsidian) below.

---

## 🧩 First-time Obsidian setup

This template ships with its plugins **already bundled** in `.obsidian/plugins/` — including the
**Claudian** plugin (the in-app Claude chat), Tasks, Calendar, Kanban, Omnisearch, and more. You
do **not** need to download them from the community store. Two one-time steps on first open:

1. **Open the folder as a vault.** In Obsidian: *Open folder as vault* → pick this folder.
2. **Turn off Restricted Mode.** For safety, Obsidian disables third-party plugins on a new vault
   and shows a prompt. Click **Trust author & enable plugins**, or go to
   *Settings → Community plugins → Turn off Restricted Mode*. The bundled plugins then load
   immediately — no installing required.
3. **Set up the Claudian plugin.** It's preinstalled but needs access to Claude: install the
   [`claude` CLI](https://claude.com/claude-code) and sign in. Then open the Claudian panel and
   point it at this vault as its working directory.

Notes:
- Bundled plugins are **pinned** to the versions committed here. To get the latest, update them
  from *Settings → Community plugins* anytime.
- If you'd rather not use the bundled copies, you can delete `.obsidian/plugins/` and install each
  plugin fresh from the community store — `community-plugins.json` lists which ones to enable.

---

## 💻 Using it without Obsidian *(optional)*

Obsidian is the recommended interface, but the assistant works just as well from the command line — the vault is plain Markdown files and Claude doesn't need a GUI to read them:

- **`CLAUDE.md`** is auto-loaded by Claude Code when you run it in this folder. That's what makes
  Claude behave as your Dispatch assistant.
- **`/setup` and `/eod`** live in `.claude/commands/` and work in any Claude Code session here.
- **The daily briefing** runs off the `claude` CLI + a scheduler (`setup/`) — it never touches Obsidian.
- Tasks, projects, and notes are all editable as Markdown in any editor.

What you give up by skipping Obsidian is purely cosmetic/convenience:
- ` ```tasks ` / ` ```dataview ` blocks render as plain code instead of live, filtered lists.
- `[[wikilinks]]` aren't clickable; banners, folder icons, Kanban boards, and the calendar don't render.
- No in-app chat UI — you'd use the Claude Code CLI (or another client) instead of the Claudian plugin.

To use it headless: `git clone`, then run Claude Code in the folder and say *"Run a briefing"* or `/setup`.

---

## 🔌 Connecting your tools

dispatch.md is most useful when it can see your real work. Two kinds of connections:

| Tool | How it connects |
|------|----------------|
| **Calendar, Gmail, Slack, Google Drive, Jira** | **MCP servers** — authorize them in your Claude client's integrations / MCP settings. `/setup` checks which are already connected. |
| **GitHub** | The **`gh` CLI** — run `gh auth login` once. Use a fine-grained, **read-only** token. |

You don't need all of them. Pick what you use; `/setup` enables only those in `CLAUDE.md`.

---

## ⏰ The daily briefing

If you enable it during `/setup`, a scheduler runs every workday morning, generates
`Daily/YYYY-MM-DD.md`, and updates your `Dashboard.md`. The assets live in `setup/`:

- `morning-briefing.sh` — the runner script
- `morning-briefing-prompt.txt` — the instructions Claude follows to build the briefing
- `com.user.morning-briefing.plist` — a macOS LaunchAgent template

On macOS these get installed to `~/.local/bin/` and `~/Library/LaunchAgents/`. On Linux, `/setup`
helps you set up a `cron` job or `systemd --user` timer instead. You can always trigger one
manually by asking Dispatch: **"Run a briefing."**

---

## 📂 What's in here

```
README.md                ← you are here
CLAUDE.md                ← dispatch.md's brain: identity, integrations, rules (templated)
Dashboard.md             ← your daily home base (starts with a worked example)
Daily/                   ← one note per day (auto-generated)
Projects/
  README.md              ← project index
  Sample Project.md      ← example project — delete once you have real ones
  Archive/               ← completed projects
Notes/                   ← meeting notes & one-offs
Templates/               ← Daily Briefing / Project / Meeting Note templates
Reference/
  Dispatch Setup.md      ← the full human-readable guide
setup/                   ← briefing script, prompt, and scheduler (used by /setup)
.claude/commands/
  setup.md               ← the /setup command
  eod.md                 ← the /eod end-of-day roundup
```

---

## 💡 Tips for getting the most out of dispatch.md

1. **Open the Dashboard first thing.** It's the single source of truth for what's in flight.
2. **Run `/eod` at the end of the day.** A 3-minute interview keeps tomorrow's briefing sharp —
   it's the difference between a generic summary and one that actually knows your day.
3. **One task, one place.** Add tasks in the most relevant note (project, meeting, daily). The
   Tasks plugin surfaces them everywhere. Date the important ones with `📅 YYYY-MM-DD`.
4. **Make a project note per real thread of work.** Duplicate the Project template. Project notes
   are where decisions and history live so you don't have to remember them.
5. **Link aggressively** with `[[wikilinks]]`. The connections make search and the graph useful.
6. **Keep `CLAUDE.md` current.** When your team, tools, or focus change, update it — stale config
   means stale briefings. You can just tell Dispatch "update my role to X."
7. **Talk to it in plain language.** "Summarize my open tasks", "What did I decide about auth?",
   "Create a meeting note for the design review", "Archive the X project."
8. **Use read-only tokens** and never commit secrets into vault files.
9. **Don't over-organize early.** Use Daily + Projects + Notes for a couple of weeks before adding
   more structure.

---

## 🔁 Sharing this with others

To pass this template on, share this folder **before** running `/setup` (or re-clone a fresh copy).
The committed state is fully generic — no personal data. The `.gitignore` keeps generated daily
notes, personal Obsidian state, and session history out of version control.

---

Happy organizing. Open `Dashboard.md`, run `/setup`, and meet your assistant. 🤖
