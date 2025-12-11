import 'package:flutter/material.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _employees = [
    {"name": "Ali Khan", "role": "Farm Supervisor", "present": true, "in": "09:00 AM", "out": "05:30 PM"},
    {"name": "Sara Noor", "role": "Technician", "present": false, "in": "-", "out": "-"},
    {"name": "Bilal Ahmed", "role": "Operator", "present": true, "in": "09:15 AM", "out": "05:10 PM"},
    {"name": "Hina Raza", "role": "Quality Analyst", "present": true, "in": "09:05 AM", "out": "05:45 PM"},
  ];

  DateTime _selectedDate = DateTime.now();
  late AnimationController _headerCtrl;
  late AnimationController _listCtrl;
  late Animation<double> _headerOpacity;
  late Animation<double> _listOpacity;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _listCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _headerOpacity = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeInOut);
    _listOpacity = CurvedAnimation(parent: _listCtrl, curve: Curves.easeInOut);
    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () => _listCtrl.forward());
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF196339);
    final borderColor = const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              // Header card (logo + date summary)
              FadeTransition(
                opacity: _headerOpacity,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 44,
                          height: 44,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.agriculture, color: primaryGreen),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fisheries Department',
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formattedDate(_selectedDate),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          '${_employees.where((e) => e["present"] == true).length}/${_employees.length} present',
                          style: const TextStyle(
                            color: primaryGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Employee list
              Expanded(
                child: FadeTransition(
                  opacity: _listOpacity,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _employees.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final emp = _employees[index];
                      return _employeeCard(emp, primaryGreen, borderColor, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Attendance saved'),
              backgroundColor: primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Save', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp, Color primaryGreen, Color borderColor, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person, color: primaryGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emp["name"],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    emp["role"],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _timeChip('In: ${emp["in"]}', primaryGreen, borderColor),
                      const SizedBox(width: 8),
                      _timeChip('Out: ${emp["out"]}', primaryGreen, borderColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: emp["present"] as bool,
              activeColor: primaryGreen,
              onChanged: (v) {
                setState(() => emp["present"] = v);
                if (!v) {
                  emp["in"] = "-";
                  emp["out"] = "-";
                } else {
                  emp["in"] = "09:00 AM";
                  emp["out"] = "05:30 PM";
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeChip(String text, Color primaryGreen, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primaryGreen,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formattedDate(DateTime d) {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF196339),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }
}

