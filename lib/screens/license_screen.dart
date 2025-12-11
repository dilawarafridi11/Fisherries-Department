import 'dart:io';
import 'package:flutter/material.dart';
import 'submitted_application_screen.dart'; // Link to submitted applications screen

class FisheriesLicenseFormScreen extends StatefulWidget {
  const FisheriesLicenseFormScreen({super.key});

  @override
  State<FisheriesLicenseFormScreen> createState() =>
      _FisheriesLicenseFormScreenState();
}

class _FisheriesLicenseFormScreenState
    extends State<FisheriesLicenseFormScreen>
    with TickerProviderStateMixin {
  // Enhanced Color Palette
  final Color primaryGreen = const Color(0xFF1F5E3C);
  final Color secondaryGreen = const Color(0xFF2E8B57);
  final Color accentBlue = const Color(0xFF2196F3);
  final Color accentOrange = const Color(0xFFFF9800);
  final Color accentPurple = const Color(0xFF9C27B0);
  final Color backgroundColor = const Color(0xFFF5FBF8);
  final Color fieldBackgroundColor = const Color(0xFFF8F9FA);
  final Color borderColor = const Color(0xFFDCE4EC);

  bool isAgreed = false;
  bool isSubmitting = false;
  bool isDownloading = false;
  File? _selectedImage;
  // final ImagePicker _picker = ImagePicker(); // removed dependency

  // Animation controllers
  AnimationController? _headerAnimationController;
  AnimationController? _formAnimationController;
  AnimationController? _buttonAnimationController;
  AnimationController? _floatingButtonController;
  Animation<double>? _headerAnimation;
  Animation<double>? _formAnimation;
  Animation<double>? _buttonAnimation;
  Animation<double>? _floatingButtonAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingButtonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController!,
      curve: Curves.easeOut,
    );

    _formAnimation = CurvedAnimation(
      parent: _formAnimationController!,
      curve: Curves.easeOut,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _buttonAnimationController!,
      curve: Curves.elasticOut,
    );

    _floatingButtonAnimation = CurvedAnimation(
      parent: _floatingButtonController!,
      curve: Curves.easeInOut,
    );

    // Start animations
    _headerAnimationController!.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController?.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _buttonAnimationController?.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      _floatingButtonController?.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController?.dispose();
    _formAnimationController?.dispose();
    _buttonAnimationController?.dispose();
    _floatingButtonController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Placeholder since image_picker is not available
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Text('Image picking not available. Please add image_picker to pubspec.'),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decoration with gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor,
                    const Color(0xFFE8F5E9),
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Wave pattern decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryGreen.withOpacity(0.1),
                      secondaryGreen.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerAnimation ?? const AlwaysStoppedAnimation(1.0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(_headerAnimation ?? const AlwaysStoppedAnimation(1.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryGreen,
                secondaryGreen,
                const Color(0xFF4CAF50),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image(
                    image: const AssetImage('assets/images/logo.png'),
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Department of Fisheries",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Khyber Pakhtunkhwa, Pakistan",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "🐟 License Application Form",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return FadeTransition(
      opacity: _formAnimation ?? const AlwaysStoppedAnimation(1.0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_formAnimation ?? const AlwaysStoppedAnimation(1.0)),
        child: Card(
          elevation: 12,
          shadowColor: primaryGreen.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryGreen.withOpacity(0.1),
                            secondaryGreen.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.description, color: primaryGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "License Details",
                      style: TextStyle(
                        color: Color(0xFF1F5E3C),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.priority_high, color: accentOrange, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Required",
                            style: TextStyle(
                              color: accentOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryGreen,
                        secondaryGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Row 1: Name and Renewal ---
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildLabeledField("Name of Applicant", isRequired: true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: _buildLabeledField(
                        "Renewal",
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),

                // --- Row 2: License, Label, and Date ---
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildLabeledField("Fish Farm License", isRequired: true),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ), // Align with fields
                      child: Text(
                        "Renewal",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildLabeledField(
                        "Valid Until",
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ],
                ),

                // --- Column: Name & Validity ---
                _buildLabeledField("Name & Validity", isRequired: true),

                // --- Row 3: Nurse Number Label & Field ---
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "License Number",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildLabeledField(
                        null,
                        initialValue: "Fish Farm Operation",
                      ),
                    ),
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
                        child: Text(
                          "Name & Addressee",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildLabeledField(null, initialValue: "Year"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Columns: Following fields are stacked ---
                _buildLabeledField(
                  "Name of Water Body",
                  initialValue: "Ahmad Ali, Water Body",
                  isRequired: true,
                ),
                _buildLabeledField(
                  "Name of Water / Area",
                  initialValue: "KP-FARM-2024",
                  isRequired: true,
                ),
                _buildLabeledField("Type of Fee Payment", initialValue: "Peshawar"),
                _buildLabeledField(
                  "District Name",
                  initialValue: "Private Pond, Village Tando Adam",
                  isRequired: true,
                ),
                _buildLabeledField(
                  "Calculated Fee (PKR)",
                  initialValue: "Peshawar",
                ), // Value from image is 'Peshawar'

                const SizedBox(height: 24),

                // --- Picture Upload Field ---
                _buildPictureUploadField(),

                const SizedBox(height: 24),

                // --- Legal Text Box ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[100]!,
                        Colors.grey[200]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "آئین کے تحت مچھلی پکڑنے کے لئے درج ذیل شرائط لاگو ہوں گی۔ خلاف ورزی پر قانونی کاروائی ہوگی۔ 1976 ایکٹ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAgreed ? primaryGreen.withOpacity(0.05) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAgreed ? primaryGreen.withOpacity(0.3) : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isAgreed ? primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isAgreed ? primaryGreen : Colors.grey,
                            width: 1.5,
                          ),
                        ),
                        child: Checkbox(
                          activeColor: primaryGreen,
                          value: isAgreed,
                          onChanged: (val) => setState(() => isAgreed = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "I agree the terms and conditions.",
                          style: TextStyle(
                            fontSize: 14,
                            color: isAgreed ? primaryGreen : Colors.black87,
                            fontWeight: isAgreed ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Signatures ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSignature("Assistant Warden Fisheries /\nHead Watcher"),
                    _buildSignature(
                      "Assistant Director Fisheries /\nDistrict Officer Fisheries",
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Submit Button (Inside Card) ---
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryGreen,
                        secondaryGreen,
                        const Color(0xFF4CAF50),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (isAgreed) {
                        setState(() {
                          isSubmitting = true;
                        });

                        // Simulate submission process
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isSubmitting = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text('Application submitted successfully!'),
                                ],
                              ),
                              backgroundColor: primaryGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );

                          // Navigate to Submitted Applications screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SubmittedApplicationsScreen(),
                            ),
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.white),
                                SizedBox(width: 12),
                                Text('Please agree to terms and conditions'),
                              ],
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                    icon: isSubmitting
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.send, color: Colors.white, size: 22),
                    label: Text(
                      isSubmitting ? "Submitting..." : "Submit Application",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Action Buttons (Outside Card) ---
  Widget _buildMainDownloadButton() {
    return ScaleTransition(
      scale: _buttonAnimation ?? const AlwaysStoppedAnimation(1.0),
      child: Column(
        children: [
          // Main Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentBlue,
                  const Color(0xFF1976D2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: accentBlue.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubmittedApplicationsScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.list_alt_rounded,
                color: Colors.white,
                size: 24,
              ),
              label: const Text(
                "View Submitted Applications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // --- Helper Widget for Labeled Text Fields ---
  Widget _buildLabeledField(
      String? label, {
        String? initialValue,
        IconData? icon,
        bool isRequired = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryGreen,
                      secondaryGreen,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                Text(
                  "*",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: accentOrange,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: fieldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: icon != null
                  ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryGreen, size: 22),
              )
                  : null,
              isDense: true,
            ),
            onTap: () {
              // Add haptic feedback if available
            },
          ),
        ),
        const SizedBox(height: 18), // Spacing for next field
      ],
    );
  }

  // --- Helper for Signatures ---
  Widget _buildSignature(String title) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 130,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[400]!,
                Colors.grey[600]!,
                Colors.grey[400]!,
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.2),
        ),
      ],
    );
  }

  // --- Picture Upload Field ---
  Widget _buildPictureUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryGreen,
                    secondaryGreen,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Upload Your Picture",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Required",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accentOrange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: fieldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedImage != null ? primaryGreen : borderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryGreen,
                            secondaryGreen,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentOrange,
                            const Color(0xFFF57C00),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Uploaded",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryGreen.withOpacity(0.1),
                        secondaryGreen.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_upload_rounded,
                    size: 60,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tap to upload your picture",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Supported formats: JPG, PNG",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  "Maximum size: 5MB",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom clipper for wave effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height * 0.75);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.5);
    final secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
