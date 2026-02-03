import 'package:flutter/material.dart';

import '../branch/branch_screen.dart';
import '../language/language_screen.dart';
import '../registration/shipper_registration_screen.dart';
import 'helpandsupport/help_support_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      // 🔹 SIDEBAR (❌ removed const)
      drawer: _ShipperDrawer(),

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Builder(
          builder: (context) => Row(
            children: [
              // 👤 CLICKABLE PROFILE ICON
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(
                  Icons.account_circle,
                  size: 32,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 8),

              // 👤 NAME + APML CODE
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Krish Vaghani",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "APML1230",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      // 🔹 DASHBOARD BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Manage your logistics smartly",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // 📊 STATS
            Row(
              children: [
                _statCard("Total Shipments", "128", Icons.local_shipping),
                const SizedBox(width: 12),
                _statCard("In Transit", "32", Icons.sync),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _statCard("Delivered", "76", Icons.check_circle_outline),
                const SizedBox(width: 12),
                _statCard("Pending", "₹45K", Icons.payments),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _ActionTile(Icons.add_box, "Create\nShipment"),
                _ActionTile(Icons.search, "Track\nShipment"),
                _ActionTile(Icons.list_alt, "My\nOrders"),
                _ActionTile(Icons.receipt_long, "Documents"),
                _ActionTile(Icons.payments, "Payments"),
                _ActionTile(Icons.support_agent, "Support"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DRAWER =================

class _ShipperDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 🔹 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            color: Colors.orange,
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.orange, size: 32),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Krish Vaghani",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Shipper",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _drawerItem(
            Icons.person,
            "User",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShipperRegistrationScreen(),
                ),
              );
            },
          ),

          _drawerItem(
            Icons.account_tree,
            "Branch",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BranchScreen(),
                ),
              );
            },
          ),

          _drawerItem(Icons.local_shipping, "Truck Tracking", () {}),
          _drawerItem(Icons.workspace_premium, "Membership", () {}),
          _drawerItem(Icons.card_giftcard, "Refer & Earn", () {}),
          _drawerItem(
              Icons.support_agent,
              "Help & Support",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HelpSupportScreen(),
                  ),
                );
                  }),
          _drawerItem(
            Icons.language,
            "Language",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageScreen(),
                ),
              );
            },
          ),


          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.orange),
                    label: const Text("Logout"),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: onTap,
    );
  }
}

// ================= ACTION TILE =================

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionTile(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


