const fs = require('fs');

const content = fs.readFileSync('main.lua', 'utf-8');

function stripLuauComments(content) {
    let result = '';
    let i = 0;
    const len = content.length;
    
    while (i < len) {
        if (content[i] === '-' && content[i+1] === '-') {
            let isLong = false;
            let longEq = '';
            let idx = i + 2;
            if (content[idx] === '[') {
                let eqCount = 0;
                let nextIdx = idx + 1;
                while (content[nextIdx] === '=') {
                    eqCount++;
                    nextIdx++;
                }
                if (content[nextIdx] === '[') {
                    isLong = true;
                    longEq = '='.repeat(eqCount);
                    idx = nextIdx + 1;
                }
            }
            
            if (isLong) {
                let foundClose = false;
                let closePattern = ']' + longEq + ']';
                while (idx < len) {
                    if (content.substring(idx, idx + closePattern.length) === closePattern) {
                        idx += closePattern.length;
                        foundClose = true;
                        break;
                    }
                    idx++;
                }
                if (foundClose) {
                    i = idx;
                } else {
                    i = len;
                }
                continue;
            } else {
                idx = i + 2;
                while (idx < len && content[idx] !== '\n' && content[idx] !== '\r') {
                    idx++;
                }
                i = idx;
                continue;
            }
        }
        
        if (content[i] === '"') {
            result += '"';
            i++;
            while (i < len) {
                if (content[i] === '\\') {
                    result += '\\' + (content[i+1] || '');
                    i += 2;
                } else if (content[i] === '"') {
                    result += '"';
                    i++;
                    break;
                } else {
                    result += content[i];
                    i++;
                }
            }
            continue;
        }
        
        if (content[i] === "'") {
            result += "'";
            i++;
            while (i < len) {
                if (content[i] === '\\') {
                    result += '\\' + (content[i+1] || '');
                    i += 2;
                } else if (content[i] === "'") {
                    result += "'";
                    i++;
                    break;
                } else {
                    result += content[i];
                    i++;
                }
            }
            continue;
        }
        
        if (content[i] === '[') {
            let isLongStr = false;
            let longEqStr = '';
            let eqCount = 0;
            let idx = i + 1;
            while (content[idx] === '=') {
                eqCount++;
                idx++;
            }
            if (content[idx] === '[') {
                isLongStr = true;
                longEqStr = '='.repeat(eqCount);
                idx++;
            }
            
            if (isLongStr) {
                let closePattern = ']' + longEqStr + ']';
                result += content.substring(i, idx);
                i = idx;
                let foundClose = false;
                while (i < len) {
                    if (content.substring(i, i + closePattern.length) === closePattern) {
                        result += closePattern;
                        i += closePattern.length;
                        foundClose = true;
                        break;
                    }
                    result += content[i];
                    i++;
                }
                if (!foundClose) {
                    i = len;
                }
                continue;
            }
        }
        
        result += content[i];
        i++;
    }
    
    let lines = result.split('\n');
    let cleanedLines = [];
    for (let line of lines) {
        if (line.trim() !== '') {
            cleanedLines.push(line.trimEnd());
        }
    }
    return cleanedLines.join('\n');
}

const cleanedContent = stripLuauComments(content);
fs.writeFileSync('Main.lua', cleanedContent, 'utf-8');
if (fs.existsSync('main.lua')) {
    fs.unlinkSync('main.lua');
}
console.log('Successfully created Main.lua and deleted main.lua.');
