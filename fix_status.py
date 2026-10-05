import os

replacements = {
    "BookingStatus.rejected": "BookingStatus.cancelled",
    "b.status == 'completed'": "b.status == BookingStatus.jobCompleted",
    "b.status == 'cancelled'": "b.status == BookingStatus.cancelled",
    "b.status == 'pending'": "b.status == BookingStatus.requestCreated",
    "b.status == 'accepted'": "b.status == BookingStatus.professionalAccepted",
    "b.status == 'arrived'": "b.status == BookingStatus.professionalArrived",
    "b.status == 'in_progress'": "b.status == BookingStatus.jobStarted",
    "b.status == 'started'": "b.status == BookingStatus.jobStarted",
    "_updateStatus('rejected')": "_updateStatus(BookingStatus.cancelled)",
    "_updateStatus('accepted')": "_updateStatus(BookingStatus.professionalAccepted)",
    "_updateStatus('arrived')": "_updateStatus(BookingStatus.professionalArrived)",
    "_updateStatus('completed')": "_updateStatus(BookingStatus.jobCompleted)",
    "newStatus == 'completed'": "newStatus == BookingStatus.jobCompleted",
    "newStatus == 'rejected'": "newStatus == BookingStatus.cancelled",
    "newStatus == 'cancelled'": "newStatus == BookingStatus.cancelled",
}

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            original = content
            for old, new in replacements.items():
                content = content.replace(old, new)
            if content != original:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f'Updated {path}')
