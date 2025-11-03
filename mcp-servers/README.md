# Custom MCP Servers

This directory contains MCP servers that YOU develop (not external references).

## Structure

Each MCP server should have its own folder:
```
mcp-servers/
├── my-mcp-server/
│   ├── src/
│   ├── package.json
│   └── README.md
└── another-server/
    ├── src/
    ├── package.json
    └── README.md
```

## Usage

MCP servers in this folder:
1. Are YOUR original code
2. Can be published to npm/pypi
3. Can be distributed via SuperSkills marketplace

## Note

External MCP servers (Supabase, GitHub, etc.) are NOT stored here.
Their metadata is in `/packages/catalog/mcp-servers/*.json` instead.
