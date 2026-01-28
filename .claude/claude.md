# Claude's Project Instructions

You are an expert iOS developer using SwiftUI. Follow the guide in `modern-swift.md`.

## Session Startup Checklist

At the **start of every new session**, do this:

1. **Read PROGRESS.md** - Check current status, component count, and what was done last session
2. **Skim QUICK_REF.md** - Refresh on ParameterControl API (especially `ColorControl(color:)` not `selection:`)
3. **If adding components** - Open TEMPLATES.md for the component template
4. **If debugging** - Use TOOL_WORKFLOWS.md for the right MCP tools

## Memory Files

| File | Purpose | When to Read | When to Update |
|------|---------|--------------|----------------|
| `PROGRESS.md` | Track progress, status, session notes | Every session start | After completing work |
| `BLOG.md` | Developer journal, reflections | When curious about history | End of significant sessions |
| `.claude/ARCHITECTURE.md` | Project structure, file locations | When adding files | When architecture changes |
| `.claude/QUICK_REF.md` | API signatures, common mistakes | Before writing code | When discovering new patterns |
| `.claude/TEMPLATES.md` | Component template, checklists | When adding components | When template improves |
| `.claude/TOOL_WORKFLOWS.md` | MCP tool usage, workflows | When using tools | When tools change |
| `README.md` | Public documentation | When updating docs | After major milestones |

## File Maintenance Rules

### PROGRESS.md
- **Keep**: Current status, component inventory, next steps, session notes, git history
- **Update**: After each session with what was accomplished
- **Format**: Session notes should be concise summaries, not detailed API documentation

### QUICK_REF.md
- **Keep**: API signatures that are easy to get wrong, common mistakes
- **Update**: When I make a mistake that should be remembered
- **Purpose**: Prevent repeating the same errors

### TEMPLATES.md
- **Keep**: Copy-paste templates, step-by-step checklists
- **Update**: When the template or process improves
- **Purpose**: Fast, consistent component creation

### TOOL_WORKFLOWS.md
- **Keep**: MCP server inventory, when to use each tool
- **Update**: When new tools are added or workflows change
- **Purpose**: Know which tool to use for each task

### BLOG.md
- **Keep**: Developer journal entries, reflections on the process
- **Update**: At the end of sessions with significant progress
- **Purpose**: Document the journey, share insights and learnings
- **Style**: Write in first person, be reflective, share what worked and what didn't

## Working Style

1. **Before writing code**: Check QUICK_REF.md for API signatures
2. **Before adding files**: Check TEMPLATES.md for the checklist
3. **Every component**: Must include `documentationURL` parameter with Apple docs link
4. **Alphabetical ordering**: Categories and components within categories are displayed alphabetically
5. **After completing work**: Update PROGRESS.md with session notes
5. **When making mistakes**: Add to QUICK_REF.md "Mistakes to Avoid"
6. **End of significant sessions**: Write a blog entry in BLOG.md reflecting on what was accomplished, challenges faced, and insights gained

## MCP Tools Available

See TOOL_WORKFLOWS.md for full details. Key tools:
- **xcodebuild**: `build_sim`, `build_run_sim`, `screenshot`
- **xcodeproj**: `add_file` (no more manual pbxproj editing!)
- **swiftlens**: `swift_validate_file` (catch errors before build)
- **xcode-diagnostics**: `get_project_diagnostics` (structured errors)
- **apple-docs**: `search_framework_symbols`, `get_apple_doc_content`

## GitHub Repository

https://github.com/andybenedetti/swiftui_playground
