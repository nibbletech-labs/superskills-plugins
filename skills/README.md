# Standalone Skills

This directory contains standalone skills that can be installed independently.

## Structure

Each skill should have its own folder:
```
skills/
├── my-skill/
│   ├── SKILL.md          # Skill definition
│   └── README.md         # Documentation
└── another-skill/
    ├── SKILL.md
    └── README.md
```

## Usage

Skills in this folder can be:
1. Installed standalone by users
2. Referenced by plugins in `/packages/plugins/`
3. Distributed via the SuperSkills marketplace

## Note

Skills that are ONLY useful as part of a specific plugin should be placed inside that plugin's folder instead (e.g., `/packages/plugins/my-plugin/skills/`).
