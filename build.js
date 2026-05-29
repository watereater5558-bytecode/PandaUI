const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('Starting PandaUI build...');

// 1. Write build/package.lua
const packageJson = fs.readFileSync('package.json', 'utf8');
fs.writeFileSync('build/package.lua', `-- Generated from package.json | build/build.js\n\nreturn [[\n${packageJson}]]\n`);
console.log('[ ✓ ] Generated build/package.lua');

// 2. Parse package properties
const pkg = JSON.parse(packageJson);
const ver = pkg.version || '0.0.0';
const desc = pkg.description || '';
const repo = pkg.repository || '';
const disc = pkg.discord || '';
const lic = pkg.license || '';

const date = new Date().toISOString().slice(0, 10);

// 3. Generate Header
let header = fs.readFileSync('build/header.lua', 'utf8');
header = header
    .replace(/{{VERSION}}/g, ver)
    .replace(/{{BUILD_DATE}}/g, date)
    .replace(/{{DESCRIPTION}}/g, desc)
    .replace(/{{REPOSITORY}}/g, repo)
    .replace(/{{DISCORD}}/g, disc)
    .replace(/{{LICENSE}}/g, lic);

// 4. Run DarkLua
const input = 'src/Init.lua';
const tempOutput = 'dist/temp.lua';
const config = 'build/darklua.dev.config.json';
const darkluaPath = 'D:\\LuauProjects\\Tools\\darklua.exe';

if (!fs.existsSync('dist')) {
    fs.mkdirSync('dist');
}

console.log(`[ Process ] Running darklua process...`);
try {
    execSync(`"${darkluaPath}" process "${input}" "${tempOutput}" --config "${config}"`, { stdio: 'inherit' });
} catch (err) {
    console.error('[ × ] DarkLua failed');
    process.exit(1);
}

// 5. Append Temp Output to Header
const finalOutput = 'Main.lua';
const tempContent = fs.readFileSync(tempOutput, 'utf8');
fs.writeFileSync(finalOutput, header + '\n\n' + tempContent);
fs.unlinkSync(tempOutput);

const stats = fs.statSync(finalOutput);
const fileSizeInKB = Math.round(stats.size / 1024);

console.log('');
console.log(`[ ✓ ] Build completed successfully`);
console.log(`[ > ] Version: ${ver}`);
console.log(`[ > ] Size: ${fileSizeInKB}KB`);
console.log(`[ > ] Output file: ${finalOutput}`);
