import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../core/services/api_services.dart';
import '../../routes/app_routes.dart';

// ================= REGEX =================
final RegExp emailRegex =
RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

final RegExp panRegex =
RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

final RegExp aadhaarRegex =
RegExp(r'^[0-9]{12}$');

final RegExp gstRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

class ShipperRegistrationScreen extends StatefulWidget {
  const ShipperRegistrationScreen({super.key});

  @override
  State<ShipperRegistrationScreen> createState() =>
      _ShipperRegistrationScreenState();
}

class _ShipperRegistrationScreenState
    extends State<ShipperRegistrationScreen> {
  // ================= CONTROLLERS =================
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
  final tdsCtrl = TextEditingController();
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

  // ================= PREFILL FOR SIDEBAR USER =================
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await ApiService.get("/me");

      if (response["success"] == true) {
        final user = response["user"];

        fullNameCtrl.text = user["fullName"] ?? "";
        companyCtrl.text = user["companyName"] ?? "";
        phoneCtrl.text = user["mobileNumber"] ?? "";
        emailCtrl.text = user["email"] ?? "";
        gstCtrl.text = user["gstNumber"] ?? "";
        panCtrl.text = user["panNumber"] ?? "";
        aadhaarCtrl.text = user["aadhaarNumber"] ?? "";
        bankAccCtrl.text = user["bankAccountNumber"] ?? "";
        ifscCtrl.text = user["ifscCode"] ?? "";
        bankNameCtrl.text = user["bankName"] ?? "";
        holderNameCtrl.text = user["accountHolderName"] ?? "";
      }

    } catch (_) {}
  }

  // ================= VALIDATION =================
  bool _validateForm() {
    if (phoneCtrl.text.length != 10) {
      _showError("Mobile number must be 10 digits");
      return false;
    }

    if (!emailRegex.hasMatch(emailCtrl.text.trim())) {
      _showError("Enter valid email address");
      return false;
    }

    if (passwordCtrl.text.length != 6 ||
        int.tryParse(passwordCtrl.text) == null) {
      _showError("Password must be 6 digit numeric");
      return false;
    }

    if (!panRegex.hasMatch(panCtrl.text.trim().toUpperCase())) {
      _showError("Enter valid PAN number");
      return false;
    }

    if (!aadhaarRegex.hasMatch(aadhaarCtrl.text.trim())) {
      _showError("Aadhaar must be 12 digit numeric");
      return false;
    }

    if (!gstRegex.hasMatch(gstCtrl.text.trim().toUpperCase())) {
      _showError("Enter valid GST number");
      return false;
    }

    if (bankAccCtrl.text.trim() != bankAccConfirmCtrl.text.trim()) {
      _showError("Bank account numbers do not match");
      return false;
    }

    if (!accepted) {
      _showError("Please accept terms & conditions");
      return false;
    }

    return true;
  }
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );

    if (result != null) {
      final file = result.files.first;

      if (file.size > 10 * 1024 * 1024) {
        _showError("File must be under 10 MB");
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selected: ${file.name}"),
        ),
      );
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ================= UI =================
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

              _requiredLabel("Designation / Role"),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orange),
                  color: Colors.orange.withOpacity(0.05),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRole,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Row(
                          children: [
                            const Icon(Icons.badge, color: Colors.orange, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              role,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedRole = value!);
                    },
                  ),
                ),
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

              _textField(
                "Email ID",
                emailCtrl,
                keyboard: TextInputType.emailAddress,
                required: true,
              ),

              _textField(
                "6-digit Password",
                passwordCtrl,
                keyboard: TextInputType.number,
                obscure: true,
                required: true,
              ),

              const SizedBox(height: 20),
              _sectionTitle("2) Address Details"),

              _textField("Building / Apartment Number", buildingCtrl),
              _textField("Area Name", areaCtrl),
              _textField("Landmark", landmarkCtrl),
              _textField("City", cityCtrl, required: true),
              _textField("State", stateCtrl, required: true),
              _textField(
                "Country",
                TextEditingController(text: "India"),
                enabled: false,
              ),
              _textField(
                "PIN Code",
                pinCtrl,
                keyboard: TextInputType.number,
                required: true,
              ),

              const SizedBox(height: 20),
              _sectionTitle("3) Identity & Compliance"),

              _textField("GST Number", gstCtrl, required: true),
              _uploadTile("Upload GST Certificate"),

              _textField("PAN Card Number", panCtrl, required: true),
              _uploadTile("Upload PAN Card (Front Image)"),

              _textField("TDS Certificate Number", tdsCtrl, required: true),
              _uploadTile("Upload TDS Certificate"),

              _textField("Aadhaar Card Number", aadhaarCtrl, required: true),
              _uploadTile("Upload Aadhaar Front"),
              _uploadTile("Upload Aadhaar Back"),

              const SizedBox(height: 20),
              _sectionTitle("4) Bank Details"),

              _textField(
                "Bank Account Number",
                bankAccCtrl,
                keyboard: TextInputType.number,
                required: true,
              ),
              _textField(
                "Re-enter Bank Account Number",
                bankAccConfirmCtrl,
                keyboard: TextInputType.number,
                required: true,
              ),
              _textField("IFSC Code", ifscCtrl, required: true),
              _textField("Bank Name", bankNameCtrl, required: true),
              _textField(
                "Account Holder Name",
                holderNameCtrl,
                capitalized: true,
                required: true,
              ),

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

              const SizedBox(height: 20),

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
                  onPressed: () async {
                    if (!_validateForm()) return;

                    try {
                      await ApiService.post(
                        endpoint: "/auth/register",
                        body: {
                          "mobileNumber": phoneCtrl.text.trim(),
                          "email": emailCtrl.text.trim(),

                          "fullName": fullNameCtrl.text.trim(),
                          "companyName": companyCtrl.text.trim(),
                          "designation": selectedRole,

                          "password": passwordCtrl.text.trim(),

                          "buildingNumber": buildingCtrl.text.trim(),
                          "areaName": areaCtrl.text.trim(),
                          "landmark": landmarkCtrl.text.trim(),
                          "city": cityCtrl.text.trim(),
                          "state": stateCtrl.text.trim(),
                          "pinCode": pinCtrl.text.trim(),

                          "gstNumber": gstCtrl.text.trim(),
                          "tdsNumber": tdsCtrl.text.trim(),
                          "panNumber": panCtrl.text.trim(),
                          "aadhaarNumber": aadhaarCtrl.text.trim(),

                          "bankAccountNumber": bankAccCtrl.text.trim(),
                          "ifscCode": ifscCtrl.text.trim(),
                          "bankName": bankNameCtrl.text.trim(),
                          "accountHolderName": holderNameCtrl.text.trim(),
                        },
                      );

                      // ✅ Success popup
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Success"),
                          content: const Text("Login successfully completed"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.bottomNav,
                                      (route) => false,
                                );
                              },
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    } catch (e) {
                      _showError("Failed to save registration data");
                    }
                  },

                  child: const Text(
                    "Submit Registration",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
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

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _uploadTile(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: _pickFile, // ✅ WORKING NOW
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              const Icon(Icons.upload_file, color: Colors.orange),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }

}
