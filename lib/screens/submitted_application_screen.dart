import 'package:flutter/material.dart';

class SubmittedApplicationsScreen extends StatefulWidget {
  const SubmittedApplicationsScreen({super.key});

  @override
  State<SubmittedApplicationsScreen> createState() => _SubmittedApplicationsScreenState();
}

class _SubmittedApplicationsScreenState extends State<SubmittedApplicationsScreen> {
  final Color primaryGreen = const Color(0xFF1F5E3C);
  final Color backgroundColor = const Color(0xFFEDF7F2);
  final Color cardColor = Colors.white;

  // Sample data - In real app, this would come from a database
  final List<ApplicationData> applications = [
    ApplicationData(
      id: 'KP-FARM-2024-001',
      applicantName: 'Ahmad Ali',
      waterBody: 'Private Pond, Village Tando Adam',
      district: 'Peshawar',
      submittedDate: DateTime(2024, 11, 15),
      status: 'Approved',
      licenseType: 'Fish Farm Operation',
      fee: 'PKR 5,000',
    ),
    ApplicationData(
      id: 'KP-FARM-2024-002',
      applicantName: 'Muhammad Hassan',
      waterBody: 'River Side Farm',
      district: 'Mardan',
      submittedDate: DateTime(2024, 11, 20),
      status: 'Pending',
      licenseType: 'Fish Farm Operation',
      fee: 'PKR 7,500',
    ),
    ApplicationData(
      id: 'KP-FARM-2024-003',
      applicantName: 'Fatima Khan',
      waterBody: 'Lake View Fisheries',
      district: 'Swat',
      submittedDate: DateTime(2024, 11, 25),
      status: 'Under Review',
      licenseType: 'Fish Farm Operation',
      fee: 'PKR 6,000',
    ),
    ApplicationData(
      id: 'KP-FARM-2024-004',
      applicantName: 'Zainab Ahmed',
      waterBody: 'Green Valley Fish Farm',
      district: 'Abbottabad',
      submittedDate: DateTime(2024, 12, 1),
      status: 'Approved',
      licenseType: 'Fish Farm Operation',
      fee: 'PKR 8,000',
    ),
    ApplicationData(
      id: 'KP-FARM-2024-005',
      applicantName: 'Imran Shah',
      waterBody: 'Mountain Stream Fisheries',
      district: 'Dir',
      submittedDate: DateTime(2024, 12, 5),
      status: 'Rejected',
      licenseType: 'Fish Farm Operation',
      fee: 'PKR 4,500',
    ),
  ];

  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredApplications = _getFilteredApplications();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        title: const Text(
          'Submitted Applications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(filteredApplications.length),
          _buildFilterChips(),
          Expanded(
            child: filteredApplications.isEmpty
                ? _buildEmptyState()
                : _buildApplicationsList(filteredApplications),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.assignment_turned_in,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 12),
          Text(
            '$count Application${count != 1 ? 's' : ''}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track your license applications',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Approved', 'Pending', 'Under Review', 'Rejected'];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: primaryGreen.withOpacity(0.2),
              checkmarkColor: primaryGreen,
              labelStyle: TextStyle(
                color: isSelected ? primaryGreen : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              elevation: 2,
              pressElevation: 4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicationsList(List<ApplicationData> applications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        return _buildApplicationCard(applications[index]);
      },
    );
  }

  Widget _buildApplicationCard(ApplicationData app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showApplicationDetails(app),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.applicantName,
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            app.id,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(app.status),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.water, 'Water Body', app.waterBody),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_city, 'District', app.district),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today, 'Submitted',
                    '${app.submittedDate.day}/${app.submittedDate.month}/${app.submittedDate.year}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.payment, 'Fee', app.fee),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewDetails(app),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryGreen,
                          side: BorderSide(color: primaryGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadPDF(app),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData icon;

    switch (status) {
      case 'Approved':
        badgeColor = const Color(0xFF4CAF50);
        icon = Icons.check_circle;
        break;
      case 'Pending':
        badgeColor = const Color(0xFFFFA726);
        icon = Icons.pending;
        break;
      case 'Under Review':
        badgeColor = const Color(0xFF42A5F5);
        icon = Icons.rate_review;
        break;
      case 'Rejected':
        badgeColor = const Color(0xFFEF5350);
        icon = Icons.cancel;
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No applications found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Applications with selected filter will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<ApplicationData> _getFilteredApplications() {
    if (selectedFilter == 'All') {
      return applications;
    }
    return applications.where((app) => app.status == selectedFilter).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Applications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _filterOption('All'),
            _filterOption('Approved'),
            _filterOption('Pending'),
            _filterOption('Under Review'),
            _filterOption('Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String filter) {
    return RadioListTile<String>(
      title: Text(filter),
      value: filter,
      groupValue: selectedFilter,
      activeColor: primaryGreen,
      onChanged: (value) {
        setState(() {
          selectedFilter = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showApplicationDetails(ApplicationData app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Application Details',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusBadge(app.status),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow('Application ID', app.id),
                  _buildDetailRow('Applicant Name', app.applicantName),
                  _buildDetailRow('License Type', app.licenseType),
                  _buildDetailRow('Water Body', app.waterBody),
                  _buildDetailRow('District', app.district),
                  _buildDetailRow('Fee Amount', app.fee),
                  _buildDetailRow('Submission Date',
                      '${app.submittedDate.day}/${app.submittedDate.month}/${app.submittedDate.year}'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _downloadPDF(app);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewDetails(ApplicationData app) {
    _showApplicationDetails(app);
  }

  void _downloadPDF(ApplicationData app) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading PDF for ${app.id}...'),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Model class for application data
class ApplicationData {
  final String id;
  final String applicantName;
  final String waterBody;
  final String district;
  final DateTime submittedDate;
  final String status;
  final String licenseType;
  final String fee;

  ApplicationData({
    required this.id,
    required this.applicantName,
    required this.waterBody,
    required this.district,
    required this.submittedDate,
    required this.status,
    required this.licenseType,
    required this.fee,
  });
}
