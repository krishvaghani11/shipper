import 'package:flutter/material.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final branchNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final buildingCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();

  String designation = "Consignor";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Add New Branch"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Branch Details"),

            _field("Branch Name", branchNameCtrl),
            _dropdown(),

            _field(
              "Mobile Number",
              mobileCtrl,
              keyboard: TextInputType.number,
              prefix: _phonePrefix(),
            ),

            _field(
              "Email Address",
              emailCtrl,
              keyboard: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),
            _section("Address Details"),

            _field("Building / Apartment Number", buildingCtrl),
            _field("Area Name", areaCtrl),
            _field("Landmark", landmarkCtrl),
            _field("City", cityCtrl),
            _field("State", stateCtrl),

            _field(
              "Country",
              TextEditingController(text: "India"),
              enabled: false,
              prefix: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text("🇮🇳"),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (branchNameCtrl.text.isEmpty) return;

                  Navigator.pop(context, {
                    "name": branchNameCtrl.text.trim(),
                    "designation": designation,
                  });
                },

                child: const Text(
                  "Save Branch",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS ----------

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: designation,
        items: const [
          DropdownMenuItem(
            value: "Consignor",
            child: Text("Consignor"),
          ),
          DropdownMenuItem(
            value: "Consignee",
            child: Text("Consignee"),
          ),
        ],
        onChanged: (v) => setState(() => designation = v!),
        decoration: InputDecoration(
          labelText: "Designation",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController ctrl, {
        TextInputType keyboard = TextInputType.text,
        bool enabled = true,
        Widget? prefix,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _phonePrefix() {
    return const Padding(
      padding: EdgeInsets.only(left: 12, right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("🇮🇳"),
          SizedBox(width: 6),
          Text("+91"),
        ],
      ),
    );
  }
}
