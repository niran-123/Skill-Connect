import json
import os

files_to_extract = {
    "11. Search Professionals": "lib/screens/customer/search_professionals_screen.dart",
    "12. Filters": "lib/screens/customer/filters_screen.dart",
    "13. Describe Problem": "lib/screens/customer/describe_problem_screen.dart",
    "14. AI Analysis": "lib/screens/customer/ai_analysis_screen.dart",
    "27. Service Requests": "lib/screens/professional/service_requests_screen.dart",
    "28. Service Request Details": "lib/screens/professional/service_request_details_screen.dart",
    "29. Accept Request Confirmation": "lib/screens/professional/accept_request_confirmation_screen.dart"
}

with open('screens.json', encoding='utf-8-sig') as f:
    d = json.load(f)

for s in d['screens']:
    title = s['title']
    if title in files_to_extract:
        file_path = files_to_extract[title]
        # Ensure directory exists
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        # Write flutter code
        with open(file_path, 'w', encoding='utf-8') as out:
            out.write(s['flutterCode'])
        print(f"Extracted {title} to {file_path}")
