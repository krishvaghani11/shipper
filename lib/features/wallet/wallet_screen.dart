import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 🔹 SHARE BANK DETAILS (NO UI CHANGE)
  void _shareBankDetails() {
    const String shareText = '''
🏦 Bank Details

Company: FR8 INDIA PRIVATE LIMITED
Account No: XXXXXXXX1234
Bank: ICICI
Branch: Mogappair West
IFSC: ICIC0000103
''';

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text("Wallet"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: "Account"),
            Tab(text: "My Payments"),
            Tab(text: "Pending Payment"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AccountTab(),
          _MyPaymentsTab(),
          _PendingPaymentsTab(),
        ],
      ),
    );
  }
}

/* ---------------------------------------------------
   ACCOUNT TAB
--------------------------------------------------- */

class _AccountTab extends StatelessWidget {
  const _AccountTab();

  @override
  Widget build(BuildContext context) {
    final parentState =
    context.findAncestorStateOfType<_WalletScreenState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_balance,
                    color: Colors.orange, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "BANK DETAILS",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      Text("FR8 INDIA PRIVATE LIMITED"),
                      Text("ACC NO : XXXXXXXX1234"),
                      Text("BANK : ICICI"),
                      Text("BRANCH : Mogappair West"),
                      Text("IFSC : ICIC0000103"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: parentState?._shareBankDetails,
                  child: const Icon(Icons.share, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            "To Top-up account",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _stepRow(
            icon: Icons.account_balance,
            text:
            "Use bank details provided above to transfer the amount",
          ),
          const SizedBox(height: 16),
          _stepRow(
            icon: Icons.currency_rupee,
            text:
            "Your account balance will be updated once the payment is processed",
          ),
        ],
      ),
    );
  }

  Widget _stepRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 26, color: Colors.black54),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}


/* ---------------------------------------------------
   MY PAYMENTS TAB (UNCHANGED)
--------------------------------------------------- */

class _MyPaymentsTab extends StatelessWidget {
  const _MyPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Amount", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Narration",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
                Icon(Icons.filter_alt_outlined, size: 18),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "No Data.",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------------------------------------
   PENDING PAYMENTS TAB (UNCHANGED)
--------------------------------------------------- */

class _PendingPaymentsTab extends StatelessWidget {
  const _PendingPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.inventory_2_outlined,
            size: 90,
            color: Colors.black26,
          ),
          SizedBox(height: 12),
          Text(
            "No trips found",
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}



