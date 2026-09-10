# MCP Server Building Skill

Load this skill when designing or building an MCP (Model Context Protocol) server so kagent (or another agent) can call external tools.

## Purpose
Build well-designed MCP servers — the interface an LLM agent uses to call external services/tools — following Anthropic's own guidance on tool design, error handling, and evaluation.

## Source
Pulled from [anthropics/skills](https://github.com/anthropics/skills) `skills/mcp-builder/` — full guide, references, and scripts vendored at [`.claude/skills/mcp-builder/`](../../.claude/skills/mcp-builder/SKILL.md) (Python/FastMCP and Node/TypeScript patterns, an evaluation script, and a best-practices reference).

## When It Applies Here
- If the kagent sample agent needs a custom tool (e.g. reading cluster state, calling an internal API), build it as an MCP server rather than baking tool logic into the agent itself.
- Reference `.claude/skills/mcp-builder/reference/mcp_best_practices.md` before writing tool schemas.

## Rules
- Prefer FastMCP (Python) or the official MCP SDK (Node) — don't hand-roll the protocol.
- Every tool needs a clear description an LLM can act on without extra context.
- Run the evaluation script (`scripts/evaluation.py`) against real task transcripts before considering a server done.
