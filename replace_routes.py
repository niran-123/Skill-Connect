import re
import os

routes_map = [
    # Paths with IDs
    (r"context\.(push|go)\(['\"]/customer/bookings/([^'\"]+)['\"]\)", r"context.\1Named('customer-booking-details', pathParameters: {'id': '\2'})"),
    (r"context\.(push|go)\(['\"]/customer/matches/([^'\"]+)['\"]\)", r"context.\1Named('customer-match-detail', pathParameters: {'id': '\2'})"),
    (r"context\.(push|go)\(['\"]/customer/review/([^'\"]+)['\"]\)", r"context.\1Named('customer-review', pathParameters: {'id': '\2'})"),
    (r"context\.(push|go)\(['\"]/professional/job/([^'\"]+)['\"]\)", r"context.\1Named('professional-job-execution', pathParameters: {'id': '\2'})"),
    
    # Exact paths
    (r"context\.(push|go)\(['\"]/login['\"]\)", r"context.\1Named('login')"),
    (r"context\.(push|go)\(['\"]/signup['\"]\)", r"context.\1Named('signup')"),
    (r"context\.(push|go)\(['\"]/forgot-password['\"]\)", r"context.\1Named('forgot-password')"),
    (r"context\.(push|go)\(['\"]/pro-registration['\"]\)", r"context.\1Named('pro-registration')"),
    (r"context\.(push|go)\(['\"]/role-selection['\"]\)", r"context.\1Named('role-selection')"),
    (r"context\.(push|go)\(['\"]/onboarding['\"]\)", r"context.\1Named('onboarding')"),

    (r"context\.(push|go)\(['\"]/customer/home['\"]\)", r"context.\1Named('customer-home')"),
    (r"context\.(push|go)\(['\"]/customer/request['\"]\)", r"context.\1Named('customer-request')"),
    (r"context\.(push|go)\(['\"]/customer/matches['\"]\)", r"context.\1Named('customer-matches')"),
    (r"context\.(push|go)\(['\"]/customer/bookings['\"]\)", r"context.\1Named('customer-bookings')"),
    (r"context\.(push|go)\(['\"]/customer/booking-request['\"]\)", r"context.\1Named('customer-booking-request')"),
    (r"context\.(push|go)\(['\"]/customer/booking-sent['\"]\)", r"context.\1Named('customer-booking-sent')"),
    (r"context\.(push|go)\(['\"]/customer/notifications['\"]\)", r"context.\1Named('customer-notifications')"),
    (r"context\.(push|go)\(['\"]/customer/profile['\"]\)", r"context.\1Named('customer-profile')"),
    (r"context\.(push|go)\(['\"]/customer/profile/edit['\"]\)", r"context.\1Named('customer-profile-edit')"),
    (r"context\.(push|go)\(['\"]/customer/saved-pros['\"]\)", r"context.\1Named('customer-saved-pros')"),
    
    (r"context\.(push|go)\(['\"]/professional/dashboard['\"]\)", r"context.\1Named('professional-dashboard')"),
    (r"context\.(push|go)\(['\"]/professional/settings['\"]\)", r"context.\1Named('professional-settings')"),
    (r"context\.(push|go)\(['\"]/admin['\"]\)", r"context.\1Named('admin')"),
]

def replace_routes():
    directory = 'd:/MAD/Skill-connect/lib'
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                original_content = content
                
                for pattern, replacement in routes_map:
                    content = re.sub(pattern, replacement, content)
                
                if original_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Updated {filepath}")

if __name__ == '__main__':
    replace_routes()
