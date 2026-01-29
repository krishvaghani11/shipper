import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shipper/features/dashboard/dashboard_screen.dart';


class ShipperRegistrationScreen extends StatefulWidget {
  const ShipperRegistrationScreen({super.key});

  @override
  State<ShipperRegistrationScreen> createState() =>
      _ShipperRegistrationScreenState();
}

class _ShipperRegistrationScreenState
    extends State<ShipperRegistrationScreen> {
  // Controllers
  final fullNameCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final buildingCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();

  final gstCtrl = TextEditingController();
  final panCtrl = TextEditingController();
  final aadhaarCtrl = TextEditingController();

  final bankAccCtrl = TextEditingController();
  final bankAccConfirmCtrl = TextEditingController();
  final ifscCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final holderNameCtrl = TextEditingController();

  bool accepted = false;

  final roles = [
    "Founder",
    "CEO",
    "Manager",
    "Admin",
    "Technical Support",
    "Consignor",
    "Consignee",
  ];

  String selectedRole = "Manager";

  PlatformFile? gstFile;
  PlatformFile? panFile;
  PlatformFile? aadhaarFront;
  PlatformFile? aadhaarBack;

  /// FILE PICKER (PDF/JPG/JPEG/PNG < 10MB)
  Future<void> _pickFile(Function(PlatformFile) onPicked) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final file = result.files.first;
      final sizeMB = file.size / (1024 * 1024);

      if (sizeMB > 10) {
        _showSnack("File must be under 10 MB");
        return;
      }

      setState(() => onPicked(file));
    }
  }

  void _submit() {
    if (!accepted) {
      _showSnack("Please accept all policies");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text("Shipper Registration"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("1) Personal & Company Details"),

              _textField("Full Name", fullNameCtrl, required: true),
              _textField("Company Name", companyCtrl, required: true),

              // 🔥 ATTRACTIVE ROLE SELECTION
              _requiredLabel("Designation / Role"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: roles.map((role) {
                  final isSelected = selectedRole == role;
                  return ChoiceChip(
                    label: Text(role),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    onSelected: (_) =>
                        setState(() => selectedRole = role),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              _requiredLabel("Mobile Number"),
              const SizedBox(height: 6),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: _inputDecoration(
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("🇮🇳"),
                        SizedBox(width: 6),
                        Text("+91"),
                      ],
                    ),
                  ),
                ).copyWith(counterText: ""),
              ),

              _textField("Email ID", emailCtrl,
                  keyboard: TextInputType.emailAddress,
                  required: true),

              _textField("6-digit Password", passwordCtrl,
                  keyboard: TextInputType.number,
                  obscure: true,
                  required: true),

              const SizedBox(height: 20),
              _sectionTitle("2) Address Details"),

              _textField("Building / Apartment Number", buildingCtrl),
              _textField("Area Name", areaCtrl),
              _textField("Landmark", landmarkCtrl),
              _textField("City", cityCtrl, required: true),
              _textField("State", stateCtrl, required: true),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Country"),
                    const SizedBox(height: 6),
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: "India"),
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          width: 48,
                          alignment: Alignment.center,
                          child: const Text(
                            "🇮🇳",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              _textField("PIN Code", pinCtrl,
                  keyboard: TextInputType.number,
                  required: true),

              const SizedBox(height: 20),
              _sectionTitle("3) Identity & Compliance"),

              _textField("GST Number", gstCtrl, required: true),
              _uploadTile(
                "Upload GST Certificate",
                gstFile,
                    () => _pickFile((f) => gstFile = f),
              ),

              _textField("PAN Card Number", panCtrl, required: true),
              _uploadTile(
                "Upload PAN Card (Front)",
                panFile,
                    () => _pickFile((f) => panFile = f),
              ),

              _textField("Aadhaar Card Number", aadhaarCtrl,
                  required: true),
              _uploadTile(
                "Upload Aadhaar Front",
                aadhaarFront,
                    () => _pickFile((f) => aadhaarFront = f),
              ),
              _uploadTile(
                "Upload Aadhaar Back",
                aadhaarBack,
                    () => _pickFile((f) => aadhaarBack = f),
              ),

              const SizedBox(height: 20),
              _sectionTitle("4) Bank Details"),

              _textField("Bank Account Number", bankAccCtrl,
                  keyboard: TextInputType.number,
                  required: true),
              _textField("Re-enter Bank Account Number",
                  bankAccConfirmCtrl,
                  keyboard: TextInputType.number,
                  required: true),
              _textField("IFSC Code", ifscCtrl, required: true),
              _textField("Bank Name", bankNameCtrl, required: true),
              _textField("Account Holder Name", holderNameCtrl,
                  capitalized: true,
                  required: true),

              const SizedBox(height: 20),
              _sectionTitle("5) Confirmation"),

              Row(
                children: [
                  Checkbox(
                    value: accepted,
                    activeColor: Colors.orange,
                    onChanged: (v) =>
                        setState(() => accepted = v ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      "I accept Terms & Conditions, Privacy Policy & Refund Policy",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "* Indicates mandatory fields",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.deepOrange),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Submit Registration",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange),
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black87),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _textField(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
        bool obscure = false,
        bool enabled = true,
        bool capitalized = false,
        bool required = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          required ? _requiredLabel(label) : Text(label),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            obscureText: obscure,
            enabled: enabled,
            textCapitalization: capitalized
                ? TextCapitalization.words
                : TextCapitalization.none,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({Widget? prefix}) {
    return InputDecoration(
      prefixIcon: prefix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _uploadTile(
      String title, PlatformFile? file, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              const Icon(Icons.upload_file,
                  color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file == null ? title : file.name,
                  style: TextStyle(
                      color: file == null
                          ? Colors.black
                          : Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

