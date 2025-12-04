#!/usr/bin/env node
/**
 * Validates SKILL.md frontmatter against required schema.
 * Run before registry generation to catch errors early.
 * Exit code 1 if validation fails.
 */

const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');

const REPO_ROOT = path.join(__dirname, '..');

// Required fields - must be present and non-empty
const REQUIRED_FIELDS = ['name', 'displayName', 'description'];

// Optional fields with defaults
const OPTIONAL_FIELDS = {
  category: 'uncategorized',
  tags: [],
  icon: 'file-text',
  author: 'unknown',
  version: '1.0.0',
};

// Valid categories (extend as needed)
const VALID_CATEGORIES = [
  'marketplace',
  'database',
  'development',
  'documentation',
  'testing',
  'deployment',
  'ai',
  'uncategorized',
];

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

function validateSkill(filePath) {
  const relativePath = path.relative(REPO_ROOT, filePath);
  const content = fs.readFileSync(filePath, 'utf-8');
  const { data: frontmatter } = matter(content);
  const errors = [];

  // Check required fields
  for (const field of REQUIRED_FIELDS) {
    if (!frontmatter[field]) {
      errors.push(`Missing required field: ${field}`);
    } else if (typeof frontmatter[field] === 'string' && !frontmatter[field].trim()) {
      errors.push(`Empty required field: ${field}`);
    }
  }

  // Validate name format (slug)
  if (frontmatter.name && !/^[a-z0-9-]+$/.test(frontmatter.name)) {
    errors.push(`Invalid name format: "${frontmatter.name}" (must be lowercase with hyphens only)`);
  }

  // Validate category if provided
  if (frontmatter.category && !VALID_CATEGORIES.includes(frontmatter.category)) {
    errors.push(`Invalid category: "${frontmatter.category}" (valid: ${VALID_CATEGORIES.join(', ')})`);
  }

  // Validate tags is an array
  if (frontmatter.tags && !Array.isArray(frontmatter.tags)) {
    errors.push(`Tags must be an array, got: ${typeof frontmatter.tags}`);
  }

  // Validate version format (loose semver)
  if (frontmatter.version && !/^\d+(\.\d+)*$/.test(frontmatter.version)) {
    errors.push(`Invalid version format: "${frontmatter.version}" (expected semver like 1.0.0)`);
  }

  return { path: relativePath, frontmatter, errors };
}

function main() {
  console.log('Validating SKILL.md frontmatter...\n');

  const skillFiles = findSkillFiles(REPO_ROOT);
  console.log(`Found ${skillFiles.length} skill file(s)\n`);

  let hasErrors = false;
  const results = skillFiles.map(validateSkill);

  for (const result of results) {
    if (result.errors.length > 0) {
      hasErrors = true;
      console.log(`X ${result.path}`);
      for (const error of result.errors) {
        console.log(`   - ${error}`);
      }
      console.log('');
    } else {
      console.log(`OK ${result.path}`);
    }
  }

  console.log('');

  if (hasErrors) {
    console.log('Validation FAILED - fix errors above before generating registry');
    process.exit(1);
  } else {
    console.log('Validation PASSED - all skills have valid frontmatter');
    process.exit(0);
  }
}

main();
