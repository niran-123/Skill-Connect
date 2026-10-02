import os

def update_file(filepath, replacements):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    for old, new in replacements:
        content = content.replace(old, new)
        
    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")
    else:
        print(f"No changes made to {filepath}")

def main():
    filepath = 'd:/MAD/Skill-connect/lib/screens/customer/customer_home_screen.dart'
    update_file(filepath, [
        (
            "import 'package:go_router/go_router.dart';",
            "import 'package:go_router/go_router.dart';\nimport 'package:provider/provider.dart';\nimport '../../providers/session_provider.dart';"
        ),
        (
            "  Widget build(BuildContext context) {",
            "  Widget build(BuildContext context) {\n    final user = context.watch<SessionProvider>().userModel;\n    final firstName = user?.name.split(' ').first ?? 'Customer';"
        ),
        (
            "Text('Good Morning, Rahul 👋'",
            "Text('Good Morning, $firstName 👋'"
        ),
        (
            "  Widget _buildServiceChip(IconData icon, String label) {\n    return Container(",
            "  Widget _buildServiceChip(BuildContext context, IconData icon, String label) {\n    return GestureDetector(\n      onTap: () => context.pushNamed('customer-request', extra: label),\n      child: Container("
        ),
        (
            "_buildServiceChip(Icons.electrical_services, 'Electrician'),",
            "_buildServiceChip(context, Icons.electrical_services, 'Electrician'),"
        ),
        (
            "_buildServiceChip(Icons.plumbing, 'Plumber'),",
            "_buildServiceChip(context, Icons.plumbing, 'Plumber'),"
        ),
        (
            "_buildServiceChip(Icons.handyman, 'Carpenter'),",
            "_buildServiceChip(context, Icons.handyman, 'Carpenter'),"
        ),
        (
            "_buildServiceChip(Icons.ac_unit, 'AC Repair'),",
            "_buildServiceChip(context, Icons.ac_unit, 'AC Repair'),"
        ),
        (
            "_buildServiceChip(Icons.car_repair, 'Mechanic'),",
            "_buildServiceChip(context, Icons.car_repair, 'Mechanic'),"
        ),
        (
            "    );\n  }",
            "    ),\n    );\n  }"
        ),
        (
            "      child: Column(\n        children: [\n          Icon(icon, color: primary, size: 28),\n          const SizedBox(height: 8),\n          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),\n        ],\n      ),\n    ),\n    );\n  }",
            "      child: Column(\n        children: [\n          Icon(icon, color: primary, size: 28),\n          const SizedBox(height: 8),\n          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),\n        ],\n      ),\n    )\n    );\n  }"
        )
    ])

if __name__ == '__main__':
    main()
