import { cpSync, mkdirSync, readdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

// Publish only the four game payloads; build output never becomes source evidence.
const repository = fileURLToPath(new URL('.', import.meta.url));
const destination = process.env.MAKEFUN_OUTPUT_DIR || '/output';
const validName = /^[A-Za-z0-9_][A-Za-z0-9_.-]*$/;
function validateTree(directory: string): void {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    if (!validName.test(entry.name) || entry.isSymbolicLink()) {
      throw new Error(`Unsupported payload entry: ${entry.name}`);
    }
    if (entry.isDirectory()) validateTree(join(directory, entry.name));
  }
}
for (const directory of ['src', 'screenshots']) validateTree(join(repository, directory));
mkdirSync(destination, { recursive: true });
for (const payload of ['game.rbxl', 'PLAY.json', 'src', 'screenshots']) {
  cpSync(join(repository, payload), join(destination, payload), { recursive: true });
}
const dossier = buildDossier(destination, {
  text_max_bytes: 65536,
  screenshots: { max: 4, max_bytes: 262144 },
  max_instances: 500000,
  scripts_max_source_bytes: 8388608,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(destination, 'dossier.json'), dossier);
