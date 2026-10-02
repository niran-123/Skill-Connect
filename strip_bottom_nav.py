import re
import os

files_to_strip = [
    'lib/screens/professional/pro_profile_view_screen.dart',
    'lib/screens/professional/pro_notifications_screen.dart',
    'lib/screens/professional/professional_dashboard.dart',
    'lib/screens/professional/job_history_screen.dart',
    'lib/screens/professional/demo_earnings_screen.dart',
    'lib/screens/professional/service_requests_screen.dart',
    'lib/screens/customer/customer_profile_screen.dart',
    'lib/screens/customer/customer_notifications_screen.dart',
    'lib/screens/customer/customer_home_screen.dart',
    'lib/screens/customer/customer_bookings_screen.dart'
]

def strip_bottom_nav():
    for rel_path in files_to_strip:
        path = os.path.join('d:/MAD/Skill-connect', rel_path)
        if not os.path.exists(path):
            continue
            
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # We look for "bottomNavigationBar: BottomNavigationBar(...),"
        # It's multi-line, so we'll use a regex that balances brackets or just simple matching
        # Assuming typical Flutter formatting:
        # bottomNavigationBar: BottomNavigationBar(
        # ...
        # ),
        
        # This regex matches from bottomNavigationBar: to the closing parenthesis of BottomNavigationBar,
        # but it might be tricky because of nested brackets.
        # A simpler way is to replace it by line processing.
        
        lines = content.split('\n')
        new_lines = []
        skip_mode = 0 # 0=normal, >0=inside bottomNav
        
        for line in lines:
            if 'bottomNavigationBar: BottomNavigationBar' in line:
                skip_mode = 1
                skip_mode += line.count('(') - line.count(')')
                skip_mode += line.count('[') - line.count(']')
                skip_mode += line.count('{') - line.count('}')
                continue
                
            if skip_mode > 0:
                skip_mode += line.count('(') - line.count(')')
                skip_mode += line.count('[') - line.count(']')
                skip_mode += line.count('{') - line.count('}')
                # If skip_mode reaches 0, we're done skipping this block.
                # However, there might be a trailing comma on the closing parenthesis line.
                if skip_mode <= 0:
                    skip_mode = 0
            else:
                new_lines.append(line)
                
        # Handle trailing commas specifically for the replacement if needed.
        # It's usually safe just dropping the lines.
        
        with open(path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(new_lines))

if __name__ == '__main__':
    strip_bottom_nav()
