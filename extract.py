import json

with open('screens.json', encoding='utf-8-sig') as f:
    d = json.load(f)

with open('extract_17_25.txt', 'w', encoding='utf-8') as out:
    for s in d['screens']:
        title = s['title']
        for i in range(17, 26):
            if title.startswith(f"{i}."):
                out.write(f"--- {title} ---\n")
                out.write(s['prompt'] + "\n\n")
