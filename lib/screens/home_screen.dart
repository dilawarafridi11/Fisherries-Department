import 'package:fish_farm_app/screens/license_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqua Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<String> damImages = [
    'assets/images/dam.png',
    'assets/images/river.png',
    'assets/images/streams.png',
  ];

  final List<String> damTitles = [
    'Dams',
    'Rivers ',
    'Streams ',
  ];

  final List<String> damDescriptions = [
    'Monitoring and maintaining ecological balance',
    'Protecting aquatic biodiversity',
    'Restoring natural water flow',
  ];

  int sliderIndex = 0;
  late PageController _pageController;
  Timer? _autoSlideTimer;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _shimmerController;
  late AnimationController _fabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    // make pages occupy more horizontal space (full page)
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoSlide();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _fabAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );

    // Start animations after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _shimmerController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (sliderIndex + 1) % damImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _onUserSwipe() {
    _autoSlideTimer?.cancel();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _startAutoSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: _ModernDrawer(),
      appBar: _ModernAppBar(),
      floatingActionButton: _AnimatedFab(
        animation: _fabAnimation,
        onPressed: () {
          // Quick action FAB
          _showQuickActionMenu();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Parallax Slider
            _buildHeroSection(screenWidth),

            // Quick Stats Cards
            _buildQuickStats(screenWidth),

            // Main content with staggered animations
            _buildMainContent(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(double screenWidth) {
    return Stack(
      children: [
        // Removed green background gradient to let images show fully


        // Parallax Slider
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
          child: SizedBox(
            // further reduced height for a more compact slider
            height: screenWidth < 350 ? 150 : 170,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: damImages.length,
              onPageChanged: (i) {
                setState(() => sliderIndex = i);
                _onUserSwipe();
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.hasClients) {
                      final page = _pageController.page ?? _pageController.initialPage.toDouble();
                      value = (1 - ((page - index).abs() * 0.3)).clamp(0.8, 1.0);
                    }
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.8, 1.0),
                        child: child,
                      ),
                    );
                  },
                  // Make slide tappable: wrap the slide container in GestureDetector
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the corresponding Dams/Rivers/Streams page
                      _navigateToPage(damTitles[index].trim());
                    },
                    child: Container(
                      // no horizontal margin so image fills the slide container
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image with shimmer effect
                            Stack(
                              children: [
                                Image.asset(
                                  damImages[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey.shade300,
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                  ),
                                ),
                                // Shimmer overlay
                                AnimatedBuilder(
                                  animation: _shimmerAnimation,
                                  builder: (context, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
                                          end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            // Gradient overlay for better text visibility
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            // Content with animation
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      damTitles[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      damDescriptions[index],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            "Learn More",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Animated dots indicator
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(damImages.length, (i) {
              final isActive = i == sliderIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Quick Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF196339),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Active Farms",
                      value: "24",
                      icon: Icons.water,
                      color: Colors.blue,
                      delay: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Fish Species",
                      value: "12",
                      icon: Icons.bubble_chart,
                      color: Colors.green,
                      delay: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Water Quality",
                      value: "Good",
                      icon: Icons.water_drop,
                      color: Colors.cyan,
                      delay: 200,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Alerts",
                      value: "3",
                      icon: Icons.notifications_active,
                      color: Colors.orange,
                      delay: 300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(double screenWidth) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header with animation
              _ModernSectionHeader(
                title: "Management Tools",
                icon: Icons.settings,
              ),

              const SizedBox(height: 20),

              // First row of buttons with staggered animation
              _buildButtonRow(
                children: [
                  _ModernMenuButton(
                    title: "Fish Farm",
                    icon: Icons.water,
                    color: Colors.blue,
                    delay: 0,
                    onTap: () => _navigateToPage('Fish Farm'),
                  ),
                  _ModernMenuButton(
                    title: "KP Public Water Bodies",
                    icon: Icons.public,
                    color: Colors.cyan,
                    delay: 100,
                    onTap: () => _navigateToPage('KP Public Water Bodies'),
                  ),
                  _ModernMenuButton(
                    title: "Fish Species",
                    icon: Icons.bubble_chart,
                    color: Colors.green,
                    delay: 200,
                    onTap: () => _navigateToPage('Fish Species'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Second row of buttons with staggered animation
              _buildButtonRow(
                children: [
                  _ModernMenuButton(
                    title: "Stocking",
                    icon: Icons.list_alt,
                    color: Colors.purple,
                    delay: 300,
                    onTap: () => _navigateToPage('Stocking Records'),
                  ),
                  _ModernMenuButton(
                    title: "Feeding",
                    icon: Icons.access_time,
                    color: Colors.orange,
                    delay: 400,
                    onTap: () => _navigateToPage('Feeding Schedule'),
                  ),
                  _ModernMenuButton(
                    title: "Support",
                    icon: Icons.support_agent,
                    color: Colors.red,
                    delay: 500,
                    onTap: () => _navigateToPage('Contact'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Full-width buttons with staggered animation
              _ModernSectionHeader(
                title: "Resources & Tools",
                icon: Icons.more_horiz,
              ),

              const SizedBox(height: 15),

              Column(
                children: [
                  _ModernMenuButtonFull(
                    title: "License & Certifications",
                    icon: Icons.verified_user,
                    color: Colors.indigo,
                    delay: 600,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return  FisheriesLicenseFormScreen();
                      }));
                    }
                  ),
                  const SizedBox(height: 12),
                  _ModernMenuButtonFull(
                    title: "Water Quality Monitoring",
                    icon: Icons.water_drop,
                    color: Colors.blue,
                    delay: 700,
                    onTap: () => _navigateToPage('Water Quality Monitoring'),
                  ),
                  const SizedBox(height: 12),
                  _ModernMenuButtonFull(
                    title: "Fish Disease & Treatment Guide",
                    icon: Icons.medical_services,
                    color: Colors.red,
                    delay: 800,
                    onTap: () => _navigateToPage('Fish Disease & Treatment Guide'),
                  ),
                  const SizedBox(height: 12),
                  _ModernMenuButtonFull(
                    title: "Weather & Environmental Alerts",
                    icon: Icons.cloud,
                    color: Colors.grey,
                    delay: 900,
                    onTap: () => _navigateToPage('Weather & Alerts'),
                  ),
                  const SizedBox(height: 12),
                  _ModernMenuButtonFull(
                    title: "Farm Expenses & Profit Calculator",
                    icon: Icons.calculate,
                    color: Colors.green,
                    delay: 1000,
                    onTap: () => _navigateToPage('Farm Expenses & Profit Calculator'),
                  ),
                  const SizedBox(height: 12),
                  _ModernMenuButtonFull(
                    title: "Tutorials & Training Resources",
                    icon: Icons.school,
                    color: Colors.purple,
                    delay: 1100,
                    onTap: () => _navigateToPage('Tutorial / Training'),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 40) / 3;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children.map((child) {
            return SizedBox(width: buttonWidth, child: child);
          }).toList(),
        );
      },
    );
  }

  void _navigateToPage(String pageName) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _PlaceholderPage(title: pageName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showQuickActionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickActionMenu(),
    );
  }
}

// Modern AppBar with glassmorphism effect
class _ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF196339)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const Text(
              "Fisheries Management",
              style: TextStyle(
                color: Color(0xFF196339),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Color(0xFF196339)),
                  onPressed: () {
                    // Handle notifications
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modern Drawer with glassmorphism effect
class _ModernDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF196339),
              const Color(0xFF196339).withOpacity(0.9),
              const Color(0xFF196339).withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.5, 1.0],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "John Doe",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Premium User",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Menu items
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _ModernDrawerSection(
                    title: "Quick Actions",
                    items: [
                      _ModernDrawerItem(
                        icon: Icons.water,
                        title: "Fish Farm",
                        color: Colors.blue,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.public,
                        title: "KP Public Water Bodies",
                        color: Colors.cyan,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.bubble_chart,
                        title: "Fish Species",
                        color: Colors.green,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.list_alt,
                        title: "Stocking Records",
                        color: Colors.purple,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.access_time,
                        title: "Feeding Schedule",
                        color: Colors.orange,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.support_agent,
                        title: "Contact",
                        color: Colors.red,
                      ),
                    ],
                  ),

                  _ModernDrawerSection(
                    title: "Resources",
                    items: [
                      _ModernDrawerItem(
                        icon: Icons.verified_user,
                        title: "License",
                        color: Colors.indigo,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.water_drop,
                        title: "Water Quality Monitoring",
                        color: Colors.blue,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.medical_services,
                        title: "Fish Disease & Treatment Guide",
                        color: Colors.red,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.cloud,
                        title: "Weather & Alerts",
                        color: Colors.grey,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.calculate,
                        title: "Farm Expenses & Profit Calculator",
                        color: Colors.green,
                      ),
                      _ModernDrawerItem(
                        icon: Icons.school,
                        title: "Tutorial / Training",
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernDrawerSection extends StatelessWidget {
  final String title;
  final List<_ModernDrawerItem> items;

  const _ModernDrawerSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF196339),
              fontSize: 16,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ModernDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ModernDrawerItem({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.pop(context);
        // Navigate to the respective page
      },
    );
  }
}

// Stat Card for Quick Overview
class _StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation after the specified delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ));
      },
    );
  }
}

// Modern Section Header
class _ModernSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ModernSectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF196339),
                const Color(0xFF196339).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF196339).withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF196339),
          ),
        ),
      ],
    );
  }
}

// Modern Menu Button with color customization
class _ModernMenuButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int delay;
  final VoidCallback? onTap;

  const _ModernMenuButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.delay,
    this.onTap,
  });

  @override
  State<_ModernMenuButton> createState() => _ModernMenuButtonState();
}

class _ModernMenuButtonState extends State<_ModernMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation after the specified delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            widget.color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
      },
    );
  }
}

// Modern Full-width Menu Button
class _ModernMenuButtonFull extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int delay;
  final VoidCallback? onTap;

  const _ModernMenuButtonFull({
    required this.title,
    required this.icon,
    required this.color,
    required this.delay,
    this.onTap,
  });

  @override
  State<_ModernMenuButtonFull> createState() => _ModernMenuButtonFullState();
}

class _ModernMenuButtonFullState extends State<_ModernMenuButtonFull>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation after the specified delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            widget.color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
      },
    );
  }
}

// Animated Floating Action Button
class _AnimatedFab extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  const _AnimatedFab({
    required this.animation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: const Color(0xFF196339),
            child: const Icon(Icons.add,color: Colors.white,),
          ),
        );
      },
    );
  }
}

// Quick Action Menu
class _QuickActionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF196339),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickActionItem(
                  icon: Icons.add,
                  label: "Add Farm",
                  color: Colors.blue,
                ),
                _QuickActionItem(
                  icon: Icons.water_drop,
                  label: "Check Water",
                  color: Colors.cyan,
                ),
                _QuickActionItem(
                  icon: Icons.add_chart,
                  label: "Add Record",
                  color: Colors.green,
                ),
                _QuickActionItem(
                  icon: Icons.report,
                  label: "Report Issue",
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Placeholder page for navigation
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF196339),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF196339).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.construction,
                size: 50,
                color: Color(0xFF196339),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF196339),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This page is under construction',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

