import json

with open('screens.json', encoding='utf-8-sig') as f:
    data = json.load(f)

screens = data.get('screens', [])
if not screens:
    print("No screens found.")
    exit(1)

theme = screens[0].get('theme', {})

with open('DESIGN.md', 'w', encoding='utf-8') as out:
    out.write('# SkillConnect App Design System\n\n')
    out.write('## Design Tokens\n```json\n')
    out.write(json.dumps(theme, indent=2))
    out.write('\n```\n\n')
    out.write('## Screens\n')
    for s in screens:
        title = s.get('title', 'Untitled')
        screen_id = s.get('id', 'No ID')
        prompt = s.get('prompt', 'No prompt')
        out.write(f'- **{title}** ({screen_id})\n')
        
    out.write('\n## Prompts\n')
    for s in screens:
        title = s.get('title', 'Untitled')
        prompt = s.get('prompt', 'No prompt')
        out.write(f'### {title}\n{prompt}\n\n')

print("DESIGN.md created.")
