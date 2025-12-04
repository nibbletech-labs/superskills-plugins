#!/usr/bin/env node
/**
 * Scans for SKILL.md files, parses frontmatter, generates registry.json.
 * Run validate-skills.js first to ensure frontmatter is valid.
 */

const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');

const REPO_ROOT = path.join(__dirname, '..');
const BASE_URL = 'https://raw.githubusercontent.com/nibbletech-labs/superskills-plugins/main/';
const OUTPUT_FILE = path.join(REPO_ROOT, 'registry.json');

function findSkillFiles(dir, files = []) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory() && !entry.name.startsWith('.') && entry.name !== 'node_modules') {
      findSkillFiles(fullPath, files);
    } else if (entry.name === 'SKILL.md') {
      files.push(fullPath);
    }
  }

  return files;
}

function parseSkillFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const { data: frontmatter } = matter(content);

  // Get relative path from repo root
  const relativePath = path.relative(REPO_ROOT, path.dirname(filePath));
  const skillPath = relativePath + '/';

  return {
    name: frontmatter.name,
    displayName: frontmatter.displayName || frontmatter.name,
    description: frontmatter.description || '',
    path: skillPath,
    url: BASE_URL + skillPath,
    category: frontmatter.category || 'uncategorized',
    tags: frontmatter.tags || [],
    icon: frontmatter.icon || 'file-text',
    author: frontmatter.author || 'unknown',
    version: frontmatter.version || '1.0.0',
  };
}

function main() {
  console.log('Scanning for SKILL.md files...');

  const skillFiles = findSkillFiles(REPO_ROOT);
  console.log(`Found ${skillFiles.length} skill(s)`);

  const skills = skillFiles.map(parseSkillFile);

  // Extract unique categories
  const categories = [...new Set(skills.map(s => s.category))].sort();

  const registry = {
    version: '1.0.0',
    baseUrl: BASE_URL,
    generatedAt: new Date().toISOString(),
    skills: skills.sort((a, b) => a.name.localeCompare(b.name)),
    metadata: {
      totalSkills: skills.length,
      categories,
    },
  };

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(registry, null, 2));
  console.log(`Generated registry.json with ${skills.length} skill(s)`);
}

main();
