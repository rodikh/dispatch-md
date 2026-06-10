# 📖 Claudian Setup & Vault Guide

← [[Dashboard]]

> This document explains how this Obsidian vault works, what it's for, and how to use it effectively. It is designed as a template — adapt the integrations and workflow to your own tools and team.

> 🚀 **First time here?** Run the `/setup` command in a Claude session opened on this vault.
> It walks you through your name, role, tool connections, and the optional daily briefing
> scheduler — and fills in every placeholder for you. See the repo `README.md` for details.

---

## 🧭 What This Vault Is For

This is your **personal work management system** inside Obsidian. It combines:

- **Daily briefings** — a structured morning summary that pulls from your connected tools
- **Project deep dives** — living documents per engineering project or feature
- **Meeting notes** — searchable record of decisions and action items
- **Task tracking** — using the Obsidian Tasks plugin to surface work across all notes
- **Claude integration** — via `CLAUDE.md` at the vault root, Claude reads and writes to this vault with full context

The goal: one place to capture, track, and reflect on all your engineering work — without switching tools constantly.

---

## 🤖 How Claude Integration Works

This vault has a `CLAUDE.md` file at its root. When you open a Claude Code session with this vault as the working directory, Claude automatically reads that file and loads it as its operating context. This is what makes Claude behave as "Claudian" — your vault-aware assistant — rather than a generic AI.

**`CLAUDE.md` tells Claude:**
- Your identity and role
- Which tools and integrations are wired up (Calendar, Email, Slack, Jira, GitHub, etc.)
- How to format tasks and notes
- Where things live in the vault
- Rules for archiving, linking, and updating files

**To customize Claude's behavior**, edit `CLAUDE.md` directly. Changes take effect immediately on the next session.

**`Reference/Claudian Setup.md`** (this file) is the human-readable counterpart — documentation for *you*, not the AI.

---

## 🔄 Daily Workflow

### If Using Automated Briefings
The daily briefing can be automated via a macOS LaunchAgent (or equivalent scheduler) that runs a Claude Code script each morning. It:
1. Pulls data from your connected integrations (Calendar, Email, Slack, Jira, GitHub)
2. Creates `Daily/YYYY-MM-DD.md` in the vault
3. Updates `Dashboard.md` with today's summary

If your Mac was asleep at the scheduled time, the briefing fires as soon as it wakes — no missed days.

See `CLAUDE.md` → *Daily Briefing — Local LaunchAgent* for script paths and configuration details.

### If Running Briefings Manually
Ask Claude: **"Run a briefing"** — it will fetch all connected sources and generate today's daily note for you.

### During the Day
- Add tasks anywhere using the Tasks syntax (see below)
- Use the meeting note template for any sync you join
- Link meeting notes back to relevant project notes

### End of Day (5 min)
- Check off completed tasks
- Note any blockers
- Move anything unfinished to tomorrow

---

## 📝 Creating Notes

### New Daily Briefing
1. Go to `Daily/` folder
2. Create file named `YYYY-MM-DD.md` (e.g., `2025-05-24.md`)
3. Apply the [[Templates/Daily Briefing|Daily Briefing template]]

Or just ask Claude: *"Create today's daily briefing"*

### New Project Note
1. Go to `Projects/` folder
2. Create file named after the project (e.g., `My Feature.md`)
3. Apply the [[Templates/Project|Project template]]
4. Add a row to [[Projects/README|Projects README]]
5. Link it from the **Projects** section on [[Dashboard]]

Or ask Claude: *"Create a project note for [feature name]"*

### New Meeting Note
1. Go to `Notes/` folder
2. Create file named `YYYY-MM-DD Meeting Name.md`
3. Apply the [[Templates/Meeting Note|Meeting Note template]]

---

## ✅ Task Syntax (Obsidian Tasks Plugin)

Tasks are Obsidian checkboxes with optional emoji metadata. The Tasks plugin indexes them across all your notes, so you can query them from anywhere — including the Dashboard.

### Basic task
```
- [ ] Do the thing
```

### Task with due date and priority
```
- [ ] Ship the feature 📅 2025-05-30 ⏫
```

### Priority emojis
| Emoji | Priority |
|-------|----------|
| ⏫ | Highest |
| 🔼 | High |
| (none) | Normal |
| 🔽 | Low |

### Date emojis
| Emoji | Meaning |
|-------|---------|
| 📅 | Due date |
| ⏳ | Scheduled date |
| 🛫 | Start date |

### Completing a task
Click the checkbox, or use the Tasks plugin modal (click the task → Edit task). Completed tasks get a `✅ YYYY-MM-DD` timestamp automatically.

### Tasks query blocks
Use in any note to show a filtered task list:
````
```tasks
not done
due before next week
sort by priority
```
````

---

## 🗂️ Folder Structure

```
Vault Root/
├── CLAUDE.md             ← AI configuration (read by Claude automatically)
├── Dashboard.md          ← Start here every day
├── Daily/                ← One note per day (YYYY-MM-DD.md)
├── Projects/             ← One note per engineering project
│   ├── README.md         ← Index of all active projects
│   └── Archive/          ← Completed projects (no open tasks or PRs)
├── Notes/                ← Meeting notes, ad hoc notes
├── Templates/            ← Note templates
│   ├── Daily Briefing.md
│   ├── Project.md
│   └── Meeting Note.md
└── Reference/            ← How-to docs (like this one)
    └── Claudian Setup.md
```

---

## 🔌 Obsidian Plugins

### Tasks
The core plugin for this system. Finds all checkboxes across the vault and lets you query them.
- **Key feature:** The Dashboard uses a Tasks query to show all active work in one place
- **Tip:** Always add a due date to important tasks so they surface in the Upcoming section

### Templater
Powers the template files in `Templates/`. Insert a template using:
- `Cmd+P` → "Templater: Insert template"
- Or configure folder templates so notes in `Daily/` auto-apply the Daily Briefing template

### Calendar
Provides a calendar view in the sidebar that links to daily notes. Click any date to open or create that day's briefing.

### Kanban *(optional)*
Create kanban boards in `Projects/` to track work visually. Create a new note, run "Create Kanban board", and add your project tasks.

---

## 📦 Project Archiving

When a project is **fully complete** — all PRs merged, all tickets resolved, no open tasks, no pending decisions — move it to `Projects/Archive/`.

**Steps:**
1. Move the project file to `Projects/Archive/Note Name.md`
2. Remove its section from `Dashboard.md`
3. Update `Projects/README.md` to list it as archived

Archive files are intentionally excluded from daily briefings and task summaries unless you explicitly ask about them.

---

## 🔗 Connected Integrations (Template)

Out of the box, Claudian supports the following integrations via MCP (Model Context Protocol). Configure them in `CLAUDE.md`:

| Integration | What Claude can do |
|---|---|
| **Google Calendar** | Read today's events, find free time, surface conflicts |
| **Gmail** | Search threads, summarize emails, flag important items |
| **Slack** | Read channels/threads, search for mentions, surface urgent messages |
| **Google Drive** | Search and read documents |
| **Jira** | Fetch open tickets, check sprint status, update issues |
| **GitHub** | Check open PRs, review commit activity, track branches |

To add or remove integrations, update the relevant sections in `CLAUDE.md` and ensure the corresponding MCP server is connected in your Claude Code settings.

---

## 🤖 Asking Claude for Help

Claude understands your vault and can act on it directly:

- **"Run a briefing"** — fetches all connected sources and creates today's daily note
- **"Summarize my active projects"** — reads all files in `Projects/` and gives a status summary
- **"Create a project note for [name]"** — scaffolds a new project deep dive from the template
- **"What tasks are due this week?"** — reads your notes and lists upcoming tasks
- **"Create a meeting note for [meeting name]"** — creates a new note in `Notes/`
- **"What did I decide about [topic]?"** — searches the vault for relevant notes
- **"Show me what's on my calendar today"** — queries your connected calendar
- **"Archive [project name]"** — moves the project file and cleans up Dashboard + README

---

## 💡 Tips for Effective Use

1. **One task, one place** — add tasks in the most relevant note (project, meeting, or daily briefing). The Dashboard surfaces them all via Tasks queries.

2. **Date everything** — add `📅 YYYY-MM-DD` to any task with a deadline. The Upcoming section won't show it otherwise.

3. **Use the Updates Log in project notes** — a one-line entry per significant event beats trying to remember history weeks later.

4. **Link aggressively** — use `[[Note Name]]` to connect daily briefings to projects and meetings. The graph view becomes useful over time.

5. **Don't over-organize** — use this system for 2–3 weeks before adding more structure. Start with just Daily + Projects + Notes.

6. **Weekly review** — every Friday, spend 10 min updating the **Weekly Pulse** section on the Dashboard and archiving completed project notes.

7. **Keep `CLAUDE.md` current** — if your team, tools, or projects change, update `CLAUDE.md`. Stale config leads to stale briefings.

---

## 🚀 Setting This Up From Scratch

The easiest path is the **`/setup` command** — open this vault in Claude and run `/setup`.
It interviews you, fills in `CLAUDE.md`, the Dashboard, and the briefing assets, and offers to
install the daily scheduler. If you'd rather do it by hand:

1. **Edit `CLAUDE.md`** — replace every `{{PLACEHOLDER}}` with your name, role, and integration details
2. **Connect MCP servers** — add Calendar, Gmail, Slack, Jira, GitHub etc. in your Claude settings
3. **Set up automated briefings** *(optional)* — copy the files in `setup/` into place and load the LaunchAgent (macOS) or equivalent scheduler
4. **Personalize the Dashboard** — replace the welcome content and the Sample Project
5. **Open `Dashboard.md`** and start your first daily note

---

*Last updated: 2026-05-26*
