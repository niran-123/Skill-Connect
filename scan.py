import os
import re

def scan_files(dir_path):
    results = []
    
    # Patterns to look for
    action_pattern = re.compile(r'(onPressed|onTap|onChanged|onFieldSubmitted|onSaved)\s*:\s*([^,]+),?')
    todo_pattern = re.compile(r'//\s*TODO.*', re.IGNORECASE)
    print_pattern = re.compile(r'print\(.*?\)')
    navigator_pattern = re.compile(r'Navigator\.(push|pop|pushNamed|pushReplacement|go|pushReplacementNamed)\([^)]+\)')
    
    for root, _, files in os.walk(dir_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    
                for i, line in enumerate(lines):
                    # Check for empty or basic handlers
                    if 'onPressed' in line or 'onTap' in line or 'onChanged' in line:
                        results.append(f"{file}:{i+1}: {line.strip()}")
                        # Also get the next few lines for context
                        for j in range(1, 4):
                            if i + j < len(lines):
                                results.append(f"  {lines[i+j].strip()}")
                    elif 'TODO' in line:
                        results.append(f"{file}:{i+1}: {line.strip()}")
                    elif 'print(' in line:
                        results.append(f"{file}:{i+1}: {line.strip()}")
                    elif 'context.go' in line or 'context.push' in line:
                        results.append(f"{file}:{i+1}: {line.strip()}")
                        
    return results

if __name__ == '__main__':
    lines = scan_files('d:/MAD/Skill-connect/lib/screens')
    with open('d:/MAD/Skill-connect/scratch_results.txt', 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print("Done")
