import re

def parse():
    with open('d:/MAD/Skill-connect/scratch_results.txt', 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    table_lines = [
        "# WIRING.md",
        "",
        "| Screen | Element (Label) | Current Behavior | Required Behavior | Route / Function |",
        "|---|---|---|---|---|"
    ]
    
    # Process lines
    for i in range(len(lines)):
        match = re.match(r'^([^:]+):(\d+): (.*)', lines[i])
        if not match:
            continue
            
        file_name = match.group(1).replace('.dart', '')
        code = match.group(3)
        
        context = code
        for j in range(1, 4):
            if i + j < len(lines) and not re.match(r'^[^:]+:\d+: ', lines[i+j]):
                context += " " + lines[i+j].strip()
                
        label = "Unknown"
        label_match = re.search(r'(Text|label|title).*?[\'"]([^\'"]+)[\'"]', context)
        if label_match:
            label = label_match.group(2)
        else:
            icon_match = re.search(r'Icon\(([^,)]+)\)', context)
            if icon_match:
                label = f"Icon {icon_match.group(1)}"
                
        behavior = "fake/nothing"
        req_behavior = "Connect to correct function/route"
        route_func = "Named Route / Provider call"
        
        if 'onPressed: () {}' in code or 'onTap: () {}' in code:
            behavior = "nothing"
        elif 'context.go' in code or 'context.push' in code:
            behavior = "fake route"
        elif 'TODO' in code:
            behavior = "TODO"
            
        if 'Navigator' in code:
            behavior = "works (but needs named route)"
            
        # Refine based on known requirements
        if 'login' in file_name.lower():
            if 'SignIn' in label or 'Sign In' in label:
                req_behavior = "Validate fields, sign in with Firebase Auth, read role, route to shell"
                route_func = "auth.signInWithEmail -> /customer or /professional"
        elif 'signup' in file_name.lower():
            if 'Sign Up' in label:
                req_behavior = "Validate, create account and users doc, go to Customer Home. Check terms checkbox"
                route_func = "auth.signUpWithEmail -> /customer"
                
        table_lines.append(f"| {file_name} | {label} | {behavior} | {req_behavior} | {route_func} |")
        
    with open('d:/MAD/Skill-connect/WIRING.md', 'w', encoding='utf-8') as out:
        out.write('\n'.join(table_lines))
        
if __name__ == '__main__':
    parse()
