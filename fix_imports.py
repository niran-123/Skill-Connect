import os
import re

import_stmt = "import 'package:skill_connect/core/booking_status.dart';\n"

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            if 'BookingStatus.' in content and 'booking_status.dart' not in content:
                if 'import' in content:
                    content = re.sub(r'(import .*?;)', r'\1\n' + import_stmt, content, count=1)
                else:
                    content = import_stmt + '\n\n' + content
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f'Added import to {path}')
