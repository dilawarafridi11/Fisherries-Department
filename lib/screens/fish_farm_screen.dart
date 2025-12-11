import 'package:fish_farm_app/screens/submitedforms/submitted_forms_screen.dart';
import 'package:flutter/material.dart';

class FishFarmScreen extends StatefulWidget {
  const FishFarmScreen({super.key});

  @override
  State<FishFarmScreen> createState() => _FishFarmScreenState();
}

class _FishFarmScreenState extends State<FishFarmScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Theme colors (green/white professional)
  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color secondaryGreen = const Color(0xFF66BB6A);
  final Color backgroundColor = const Color(0xFFF7FAF7);
  final Color cardColor = Colors.white;
  final Color borderColor = const Color(0xFFE0E3E0);

  // Controllers / state
  final TextEditingController _farmNameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _regNoCtrl = TextEditingController();
  final TextEditingController _certNoCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _gpsXCtrl = TextEditingController();
  final TextEditingController _gpsYCtrl = TextEditingController();
  final TextEditingController _raceWaysCtrl = TextEditingController();
  final TextEditingController _otherFishCtrl = TextEditingController();
  final TextEditingController _harvestTypeCtrl = TextEditingController();
  final TextEditingController _harvestUnitCtrl = TextEditingController();
  final TextEditingController _productionCapacityCtrl = TextEditingController();
  final TextEditingController _farmerNameCtrl = TextEditingController();
  final TextEditingController _farmerCnicCtrl = TextEditingController();
  final TextEditingController _farmerQualificationCtrl = TextEditingController();
  final TextEditingController _dependentsCtrl = TextEditingController();

  String? _typeOfFish; // dropdown value
  String? _maritalStatus; // Single/Married
  DateTime? _fishHarvestDate;

  // -- new: FocusNodes for fields to animate borders on focus
  late final List<FocusNode> _focusNodes;

  // Animations
  late final AnimationController _headerCtrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    ..forward();
  late final Animation<double> _headerOpacity =
  CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);

  late final AnimationController _formCtrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
    ..forward();
  late final Animation<double> _formOpacity =
  CurvedAnimation(parent: _formCtrl, curve: Curves.easeIn);

  @override
  void initState() {
    super.initState();
    // initialize FocusNodes for main inputs
    _focusNodes = List.generate(8, (index) => FocusNode());
    for (final node in _focusNodes) {
      node.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _formCtrl.dispose();
    _farmNameCtrl.dispose();
    _addressCtrl.dispose();
    _regNoCtrl.dispose();
    _certNoCtrl.dispose();
    _areaCtrl.dispose();
    _gpsXCtrl.dispose();
    _gpsYCtrl.dispose();
    _raceWaysCtrl.dispose();
    _otherFishCtrl.dispose();
    _harvestTypeCtrl.dispose();
    _harvestUnitCtrl.dispose();
    _productionCapacityCtrl.dispose();
    _farmerNameCtrl.dispose();
    _farmerCnicCtrl.dispose();
    _farmerQualificationCtrl.dispose();
    _dependentsCtrl.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _pickHarvestDate() async {
    final DateTime now = DateTime.now();
    final DateTime first = DateTime(now.year - 5);
    final DateTime last = DateTime(now.year + 5);
    final picked = await showDatePicker(
      context: context,
      initialDate: _fishHarvestDate ?? now,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryGreen),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _fishHarvestDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill required fields'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // ...existing code... (Persist or send data as needed)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fish Farm details submitted'),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Rebuild body to match license screen: gradient + wave + animated content
      body: Stack(
        children: [
          // Background gradient like license screen
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
          // Top wave decoration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: ClipPath(
              clipper: _FishFarmWaveClipper(), // uses top-level class now
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryGreen.withValues(alpha: 0.1),
                      secondaryGreen.withValues(alpha: 0.05),
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
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                // center card on wide screens
                final cardWidth = maxWidth > 900 ? 900.0 : maxWidth;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardWidth),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.99, end: 1.0).animate(
                        CurvedAnimation(parent: _formCtrl, curve: Curves.easeOutBack),
                      ),
                      child: FadeTransition(
                        opacity: _formOpacity,
                        child: Card(
                          color: cardColor,
                          elevation: 12,
                          shadowColor: primaryGreen.withValues(alpha: 0.18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Animated header
                                  FadeTransition(
                                    opacity: _headerOpacity,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, -0.08),
                                        end: Offset.zero,
                                      ).animate(_headerCtrl),
                                      child: _brandHeader(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _sectionHeader('Type of Fish Farm'),
                                  _field('Name of Fish Farm', _farmNameCtrl, focusNode: _focusNodes[0], required: true, icon: Icons.home_work),
                                  _field('Address', _addressCtrl, focusNode: _focusNodes[1], required: true, icon: Icons.place),
                                  _field('Registration Number', _regNoCtrl, focusNode: _focusNodes[2], icon: Icons.confirmation_number),
                                  _field('Certification Number', _certNoCtrl, focusNode: _focusNodes[3], icon: Icons.verified),
                                  Row(
                                    children: [
                                      Expanded(child: _field('Area of Fish Farms (Kannals)', _areaCtrl, focusNode: _focusNodes[4], keyboard: TextInputType.number, icon: Icons.square_foot)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _field('Farm Production Capacity', _productionCapacityCtrl, focusNode: _focusNodes[5], keyboard: TextInputType.number, icon: Icons.factory)),
                                    ],
                                  ),
                                  _sectionHeader('GPS Coordinates'),
                                  Row(
                                    children: [
                                      Expanded(child: _field('X Coordinates', _gpsXCtrl, focusNode: _focusNodes[6], keyboard: TextInputType.number, icon: Icons.my_location)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _field('Y Coordinates', _gpsYCtrl, focusNode: _focusNodes[7], keyboard: TextInputType.number, icon: Icons.location_searching)),
                                    ],
                                  ),
                                  _sectionHeader('Fish Details'),
                                  _fishTypeDropdown(),
                                  if (_typeOfFish == 'Trout')
                                    _field('Race Ways', _raceWaysCtrl, icon: Icons.water_drop),
                                  if (_typeOfFish == 'Other')
                                    _field('Other Fish Type', _otherFishCtrl, icon: Icons.edit),
                                  Row(
                                    children: [
                                      Expanded(child: _field('Type of Fish', _harvestTypeCtrl, icon: Icons.biotech)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _unitDropdown()),
                                    ],
                                  ),
                                  _datePickerField('Fish Harvest (Calendar)', _fishHarvestDate, onTap: _pickHarvestDate),
                                  _sectionHeader('Farmer Details'),
                                  _field('Farmer Name', _farmerNameCtrl, required: true, icon: Icons.person),
                                  Row(
                                    children: [
                                      Expanded(child: _field('Farmer CNIC', _farmerCnicCtrl, keyboard: TextInputType.number, icon: Icons.badge)),
                                      const SizedBox(width: 12),
                                      Expanded(child: _field('Farmer Qualification', _farmerQualificationCtrl, icon: Icons.school)),
                                    ],
                                  ),
                                  _maritalDropdown(),
                                  if (_maritalStatus == 'Married')
                                    _field('Number of dependents', _dependentsCtrl, keyboard: TextInputType.number, icon: Icons.group),
                                  const SizedBox(height: 16),
                                  _submitButton(),
                                  const SizedBox(height: 12),
                                  _viewSubmittedFormsButton(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Widgets

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 24,
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        bool required = false,
        TextInputType keyboard = TextInputType.text,
        IconData? icon,
        FocusNode? focusNode, // new param
      }) {
    // determine focused state
    final focused = focusNode?.hasFocus ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: focused ? primaryGreen : borderColor, width: focused ? 1.6 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: focused ? 0.06 : 0.03),
              blurRadius: focused ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboard,
          validator: required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: focused ? primaryGreen : Colors.black45) : null,
            labelText: label,
            labelStyle: TextStyle(color: focused ? primaryGreen : Colors.black54, fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _fishTypeDropdown() {
    const fishTypes = [
      'Trout',
      'Mahashair',
      'Rahu',
      'Mori',
      'Thaila',
      'Calbans',
      'Silver',
      'Big Head',
      'Sole',
      'Schizothorax sp',
      'Gulfaam',
      'Eel',
      'Sher Mahi',
      'Cat Fish',
      'Other',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          initialValue: _typeOfFish,
          isDense: true,
          decoration: const InputDecoration(
            labelText: 'Type of Fish',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          items: fishTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _typeOfFish = v),
        ),
      ),
    );
  }

  Widget _unitDropdown() {
    const units = ['Unit/Kg', 'Kg'];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _harvestUnitCtrl.text.isEmpty ? null : _harvestUnitCtrl.text,
        isDense: true,
        decoration: const InputDecoration(
          labelText: 'Unit/Kg',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        items: units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => _harvestUnitCtrl.text = v ?? ''),
      ),
    );
  }

  Widget _datePickerField(String label, DateTime? value, {required VoidCallback onTap}) {
    final text = value != null ? '${value.year}-${value.month}-${value.day}' : 'Select date';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.expand_more, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }

  Widget _maritalDropdown() {
    const opts = ['Single', 'Married'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          initialValue: _maritalStatus,
          isDense: true,
          decoration: const InputDecoration(
            labelText: 'Single/Married',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          items: opts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _maritalStatus = v),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, secondaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _submit,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.save_alt, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewSubmittedFormsButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1976D2), const Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          // Navigates to green-themed SubmittedFormsScreen with animations
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmittedFormsScreen()),
          );
        },
        icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
        label: const Text(
          'View Submitted Forms',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // Brand header now uses a green gradient like license screen, animated in
  Widget _brandHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryGreen,
            secondaryGreen,
            const Color(0xFF1F5E3C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo (Hero added)
          Hero(
            tag: 'logo',
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 68,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.agriculture, color: Colors.green.shade700, size: 48);
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Department of Fisheries",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "KP Fish Farm",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1F5E3C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'KP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Move the clipper to the top-level (outside of any class)
class _FishFarmWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height * 0.75);

    final Offset firstControlPoint = Offset(size.width / 4, size.height);
    final Offset firstEndPoint = Offset(size.width / 2, size.height * 0.75);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final Offset secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.5);
    final Offset secondEndPoint = Offset(size.width, size.height * 0.75);
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