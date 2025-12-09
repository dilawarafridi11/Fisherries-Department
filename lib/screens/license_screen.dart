import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FisheriesLicenseFormScreen(),
  ));
}

class FisheriesLicenseFormScreen extends StatefulWidget {
  const FisheriesLicenseFormScreen({super.key});

  @override
  State<FisheriesLicenseFormScreen> createState() => _FisheriesLicenseFormScreenState();
}

class _FisheriesLicenseFormScreenState extends State<FisheriesLicenseFormScreen> {
  // Color Palette from the image
  final Color primaryGreen = const Color(0xFF1F5E3C);
  final Color backgroundColor = const Color(0xFFEDF7F2); // Light water-like background
  final Color fieldBackgroundColor = const Color(0xFFF8F9FA);
  final Color borderColor = const Color(0xFFDCE4EC);

  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFormCard(),
              const SizedBox(height: 20),
              _buildMainDownloadButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(image: AssetImage('assets/images/logo.png'),height: 80,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Department of Fisheries",
                style: TextStyle(
                  color: Color(0xFF1F5E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "(Khyber Pakhtunkhwa) Pakistan",
                style: TextStyle(
                  color: Color(0xFF1F5E3C),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "License Form ",
                style: TextStyle(
                  color: Color(0xFF1F5E3C),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Logo Placeholder

      ],
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "License Details",
              style: TextStyle(
                color: Color(0xFF1F5E3C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // --- Row 1: Name and Renewal ---
            Row(
              children: [
                Expanded(flex: 2, child: _buildLabeledField("Name of Applicant")),
                const SizedBox(width: 12),
                Expanded(flex: 1, child: _buildLabeledField("Renewal", icon: Icons.calendar_today)),
              ],
            ),

            // --- Row 2: License, Label, and Date ---
            Row(
              children: [
                Expanded(flex: 2, child: _buildLabeledField("Fish Farm License")),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0), // Align with fields
                  child: Text("Renewal", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _buildLabeledField("Valid Until", icon: Icons.calendar_today)),
              ],
            ),

            // --- Column: Name & Validity ---
            _buildLabeledField("Name & Validity"),

            // --- Row 3: Nurse Number Label & Field ---
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("License Number", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 3, child: _buildLabeledField(null, initialValue: "Fish Farm Operation")),
              ],
            ),
            const SizedBox(height: 16),

            // --- Row 4: Name & Addressee Label & Year Field ---
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("Name & Addressee", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 3, child: _buildLabeledField(null, initialValue: "Year")),
              ],
            ),
            const SizedBox(height: 16),

            // --- Columns: Following fields are stacked ---
            _buildLabeledField("Name of Water Body", initialValue: "Ahmad Ali, Water Body"),
            _buildLabeledField("Name of Water / Area", initialValue: "KP-FARM-2024"),
            _buildLabeledField("Type of Fee Payment", initialValue: "Peshawar"),
            _buildLabeledField("District Name", initialValue: "Private Pond, Village Tando Adam"),
            _buildLabeledField("Calculated Fee (PKR)", initialValue: "Peshawar"), // Value from image is 'Peshawar'

            const SizedBox(height: 24),

            // --- Legal Text Box ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const Text(
                    "آئین کے تحت مچھلی پکڑنے کے لئے درج ذیل شرائط لاگو ہوں گی۔ خلاف ورزی پر قانونی کاروائی ہوگی۔ 1976 ایکٹ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Arial', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),


                  Text(
                    "By virtue of this writing, the holder of this license is permitted to catch fish under the 1961 Ordinance and 1976 Rules. Strict compliance with the terms is mandatory.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Checkbox ---
            Row(
              children: [
                Checkbox(
                  activeColor: primaryGreen,
                  value: isAgreed,
                  onChanged: (val) => setState(() => isAgreed = val!),
                ),
                const Text("I agree the terms and conditions.", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 24),

            // --- Signatures ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSignature("Assistant Warden Fisheries /\nHead Watcher"),
                _buildSignature("Assistant Director Fisheries /\nDistrict Officer Fisheries"),
              ],
            ),
            const SizedBox(height: 30),

            // --- Submit Button (Inside Card) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.file_download_done, color: Colors.white),
                label: const Text(
                  "Submit Application",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Main Download Button (Outside Card) ---
  Widget _buildMainDownloadButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        onPressed: () {},
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text(
          "Download PDF",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Helper Widget for Labeled Text Fields ---
  Widget _buildLabeledField(String? label, {String? initialValue, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: fieldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 16), // Spacing for next field
      ],
    );
  }

  // --- Helper for Signatures ---
  Widget _buildSignature(String title) {
    return Column(
      children: [
        Container(width: 130, height: 1.5, color: Colors.grey[400]),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2),
        ),
      ],
    );
  }
}