import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../fish_farm_screen.dart';

class SubmittedFormsScreen extends StatefulWidget {
  const SubmittedFormsScreen({super.key});

  @override
  State<SubmittedFormsScreen> createState() => _SubmittedFormsScreenState();
}

class _SubmittedFormsScreenState extends State<SubmittedFormsScreen>
    with TickerProviderStateMixin {
  // Theme
  Color get primaryGreen => const Color(0xFF2E7D32);
  Color get secondaryGreen => const Color(0xFF66BB6A);
  Color get backgroundColor => const Color(0xFFF7FAF7);
  Color get borderColor => const Color(0xFFE0E3E0);

  // Animation controllers
  late final AnimationController _headerCtrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
  late final Animation<double> _headerOpacity =
  CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);

  late final AnimationController _listCtrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _listOpacity =
  CurvedAnimation(parent: _listCtrl, curve: Curves.easeIn);

  late final AnimationController _fabCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final AnimationController _searchCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _fabAnimation = CurvedAnimation(
    parent: _fabCtrl,
    curve: Curves.easeInOut,
  );

  late final Animation<double> _searchAnimation = CurvedAnimation(
    parent: _searchCtrl,
    curve: Curves.easeInOut,
  );

  // State variables
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  // Placeholder submitted forms data
  final List<Map<String, String>> forms = [
    {
      'id': '1',
      'title': 'KP Fish Farm - Trout',
      'farmer': 'Ali Khan',
      'date': '2025-01-10',
      'location': 'Swat, KP',
      'status': 'approved',
      'type': 'Trout',
      'area': '25 acres',
    },
    {
      'id': '2',
      'title': 'KP Fish Farm - Rahu',
      'farmer': 'Sara Ahmed',
      'date': '2025-02-03',
      'location': 'Mardan, KP',
      'status': 'pending',
      'type': 'Rahu',
      'area': '15 acres',
    },
    {
      'id': '3',
      'title': 'KP Fish Farm - Cat Fish',
      'farmer': 'Zeeshan',
      'date': '2025-03-18',
      'location': 'Abbottabad, KP',
      'status': 'approved',
      'type': 'Cat Fish',
      'area': '30 acres',
    },
    {
      'id': '4',
      'title': 'KP Fish Farm - Mahashair',
      'farmer': 'Nasir Khan',
      'date': '2025-04-05',
      'location': 'Peshawar, KP',
      'status': 'rejected',
      'type': 'Mahashair',
      'area': '20 acres',
    },
  ];

  List<Map<String, String>> _getFilteredForms() {
    if (_searchQuery.isEmpty) {
      return forms;
    }

    final query = _searchQuery.toLowerCase();
    return forms.where((form) {
      final title = form['title']?.toLowerCase() ?? '';
      final farmer = form['farmer']?.toLowerCase() ?? '';
      final location = form['location']?.toLowerCase() ?? '';
      final type = form['type']?.toLowerCase() ?? '';

      return title.contains(query) ||
          farmer.contains(query) ||
          location.contains(query) ||
          type.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fabCtrl.forward();

    // Listen to scroll events to hide/show FAB
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showFab) {
          setState(() => _showFab = false);
          _fabCtrl.reverse();
        }
      } else {
        if (!_showFab) {
          setState(() => _showFab = true);
          _fabCtrl.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _listCtrl.dispose();
    _fabCtrl.dispose();
    _searchCtrl.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchCtrl.forward();
      } else {
        _searchCtrl.reverse();
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _navigateToFormDetail(Map<String, String> form) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FormDetailScreen(form: form),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    final isMobile = screenWidth < 600;

    // Calculate responsive padding
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final cardMaxWidth = isDesktop ? 1200.0 : double.infinity;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1F5E3C),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F5E3C), Color(0xFF1F5E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: [
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.search_ellipsis,
              progress: _searchAnimation,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
        centerTitle: false,
      ),
      body: FadeTransition(
        opacity: _listOpacity,
        child: RefreshIndicator(
          color: primaryGreen,
          backgroundColor: Colors.white,
          onRefresh: _refreshForms,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardMaxWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final isWide = availableWidth > 800;
                  final filteredForms = _getFilteredForms();

                  return filteredForms.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      24,
                    ),
                    itemCount: filteredForms.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return FadeTransition(
                          opacity: _headerOpacity,
                          child: _listHeader(),
                        );
                      }
                      final item = filteredForms[i - 1];
                      return _animatedFormCard(i - 1, item, isWide, isMobile, isTablet);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const FishFarmScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              },
              backgroundColor: primaryGreen,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: 'logo',
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.agriculture, color: primaryGreen),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Flexible(
          child: Text(
            'Submitted Forms',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Flexible(
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _searchController,
          autofocus: true,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search forms...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No forms submitted yet' : 'No results found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Submit your first form to see it here'
                : 'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshForms() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Forms refreshed'),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Forms'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Forms'),
              leading: Radio<String>(
                value: 'all',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
            ListTile(
              title: const Text('Approved'),
              leading: Radio<String>(
                value: 'approved',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
            ListTile(
              title: const Text('Pending'),
              leading: Radio<String>(
                value: 'pending',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: primaryGreen)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text('Apply', style: TextStyle(color: primaryGreen)),
          ),
        ],
      ),
    );
  }

  Widget _listHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.list_alt_rounded,
                  color: primaryGreen,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Text(
                  'Your Submitted Forms',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 10,
                  vertical: isMobile ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  '${_getFilteredForms().length}',
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: isMobile ? 11 : 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _animatedFormCard(int index, Map<String, String> item, bool isWide, bool isMobile, bool isTablet) {
    final start = (0.06 * index).clamp(0.0, 0.6);
    final end = (start + 0.6).clamp(0.6, 1.0);
    final anim = CurvedAnimation(
      parent: _listCtrl,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(anim);

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(anim);
    final scale = Tween<double>(begin: 0.97, end: 1.0).animate(anim);

    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: _formCard(context, item, isWide, isMobile, isTablet),
        ),
      ),
    );
  }

  Widget _formCard(BuildContext context, Map<String, String> item, bool isWide, bool isMobile, bool isTablet) {
    final String id = item['id'] ?? '';
    final String title = item['title'] ?? 'KP Fish Farm';
    final String farmer = item['farmer'] ?? '-';
    final String location = item['location'] ?? '-';
    final String date = item['date'] ?? '-';
    final String status = item['status'] ?? 'pending';
    final String type = item['type'] ?? '-';
    final String area = item['area'] ?? '-';

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    // Responsive sizing
    final avatarRadius = isMobile ? 24.0 : 28.0;
    final titleSize = isMobile ? 14.0 : 16.0;
    final textSize = isMobile ? 11.0 : 13.0;
    final iconSize = isMobile ? 18.0 : 20.0;

    return Hero(
      tag: 'form_$id',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToFormDetail(item),
          onLongPress: () => _showActionMenu(context, item),
          splashColor: primaryGreen.withOpacity(0.1),
          highlightColor: primaryGreen.withOpacity(0.05),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: primaryGreen.withOpacity(0.08),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          width: avatarRadius * 1.6,
                          height: avatarRadius * 1.6,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.agriculture,
                            color: primaryGreen,
                            size: avatarRadius,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 10 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: isMobile ? 3 : 4),
                          Text(
                            'Farmer: $farmer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: textSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isMobile ? 4 : 8),
                    IconButton(
                      onPressed: () => _navigateToFormDetail(item),
                      icon: Icon(Icons.open_in_new, color: primaryGreen, size: iconSize),
                      tooltip: 'Open',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 28 : 32,
                        minHeight: isMobile ? 28 : 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 12),
                // Status chip
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 4 : 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: isMobile ? 12 : 14),
                      SizedBox(width: isMobile ? 4 : 6),
                      Text(
                        status[0].toUpperCase() + status.substring(1),
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 11,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 10 : 12),
                // Details
                _infoRow('Location', location, Icons.location_on, isMobile),
                SizedBox(height: isMobile ? 4 : 6),
                _infoRow('Date', date, Icons.calendar_today, isMobile),
                SizedBox(height: isMobile ? 4 : 6),
                if (isWide)
                  Row(
                    children: [
                      Expanded(child: _infoRow('Type', type, Icons.category, isMobile)),
                      const SizedBox(width: 12),
                      Expanded(child: _infoRow('Area', area, Icons.square_foot, isMobile)),
                    ],
                  )
                else ...[
                  _infoRow('Type', type, Icons.category, isMobile),
                  SizedBox(height: isMobile ? 4 : 6),
                  _infoRow('Area', area, Icons.square_foot, isMobile),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon, bool isMobile) {
    final iconSize = isMobile ? 12.0 : 14.0;
    final textSize = isMobile ? 10.0 : 12.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey[600], size: iconSize),
        SizedBox(width: isMobile ? 4 : 6),
        Flexible(
          child: Text(
            '$label: $value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black54,
              fontSize: textSize,
            ),
          ),
        ),
      ],
    );
  }

  void _showActionMenu(BuildContext context, Map<String, String> form) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryGreen.withOpacity(0.1),
                    child: Icon(Icons.description, color: primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      form['title'] ?? 'Form',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.visibility, color: primaryGreen),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _navigateToFormDetail(form);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Edit functionality would be implemented here'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.purple),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Share functionality would be implemented here'),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(form);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, String> form) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Form'),
        content: Text('Are you sure you want to delete "${form['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: primaryGreen)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                forms.remove(form);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Form deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Form detail screen
class FormDetailScreen extends StatelessWidget {
  final Map<String, String> form;

  const FormDetailScreen({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final horizontalPadding = isMobile ? 16.0 : (isTablet ? 24.0 : 32.0);
    final maxWidth = screenWidth > 800 ? 800.0 : double.infinity;

    final Color primaryGreen = const Color(0xFF2E7D32);
    final Color backgroundColor = const Color(0xFFF7FAF7);

    final String title = form['title'] ?? 'KP Fish Farm';
    final String farmer = form['farmer'] ?? '-';
    final String location = form['location'] ?? '-';
    final String date = form['date'] ?? '-';
    final String status = form['status'] ?? 'pending';
    final String type = form['type'] ?? '-';
    final String area = form['area'] ?? '-';

    // Determine status color and icon
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryGreen,
        title: Text(
          'Form Details',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: primaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality would be implemented here'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with avatar and title
                Hero(
                  tag: 'avatar_${form['id']}',
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: primaryGreen.withOpacity(0.1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (_, __, ___) => Icon(Icons.agriculture, color: primaryGreen, size: 60),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title and status
                Hero(
                  tag: 'form_${form['id']}',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: primaryGreen,
                                    fontSize: isMobile ? 18 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: statusColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      status[0].toUpperCase() + status.substring(1),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _detailRow('Farmer', farmer, Icons.person, isMobile),
                          _detailRow('Location', location, Icons.location_on, isMobile),
                          _detailRow('Date', date, Icons.calendar_today, isMobile),
                          _detailRow('Type', type, Icons.category, isMobile),
                          _detailRow('Area', area, Icons.square_foot, isMobile),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit functionality would be implemented here'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12 : 14,
                            horizontal: isMobile ? 16 : 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12 : 14,
                            horizontal: isMobile ? 16 : 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

  Widget _detailRow(String label, String value, IconData icon, bool isMobile) {
    final iconSize = isMobile ? 12.0 : 14.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: iconSize),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}