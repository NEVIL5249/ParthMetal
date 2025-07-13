// In your about_us_screen.dart file

import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Consistent background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFDA2E1A), // Consistent app bar color
        elevation: 0, // Remove shadow for a flat design
        title: const Text(
          'Parth Metal Corporation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Consistent title style
        ),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView( // Scrollable content to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Consistent padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Us', // Company name
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Parth Metal Corporation, your trusted partner in high-quality stainless steel products.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Contact Information Section
              _buildInfoRow(Icons.person, 'Contact Person:', 'KANAK PATEL'), // Added Contact Person
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, 'Mobile:', '+91 93271 34002'), // Primary Mobile
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone, 'Office/Secondary Mobile:', '87584 08577'), // Secondary Mobile from handwritten
              const SizedBox(height: 12),
              _buildInfoRow(Icons.email, 'Email:', 'kanakkathiriya@gmail.com'), // Email
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on, 'Address:', 'KP Industrial Zone-2, Street No.1, Aji Ring Road, Kotnariya, Rajkot-360022.'), // Full Address
              const SizedBox(height: 24),

              // Our Commitment/Products Section
              Text(
                'Our Products & Commitment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'We are a leading supplier of a diverse range of premium stainless steel products, specializing in S.S. Patta, Coils, Scrap, and Wire Rod. At Parth Metal Corporation, Quality and customer satisfaction are at the forefront of everything we do. We strive to provide excellent steel solutions that meet the highest industry standards and cater to the specific needs of our clients.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20), // Extra space at the bottom
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 1),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFDA2E1A), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Placeholder for the bottom navigation bar, mimicking the DashboardScreen's style
  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFDA2E1A),
          unselectedItemColor: Colors.grey[400],
          currentIndex: currentIndex,
          onTap: (index) {
            // This is the crucial change
            if (index == 0) {
              // Navigate to DashboardScreen and remove all previous routes below it
              // This is the correct way to go to a main tab without creating a back stack
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
            } else if (index == 1) {
              // Stay on About Us - no action needed if already on this tab
              // If you want to ensure it's the only screen on the stack when selected,
              // you could use Navigator.pushNamedAndRemoveUntil(context, '/about', (route) => false);
              // but typically for the current active tab, you do nothing.
            } else if (index == 2) {
              Navigator.pushNamed(context, '/products'); // Navigate to ProductsScreen
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? const Color(0xFFDA2E1A).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                  size: 24,
                ),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? const Color(0xFFDA2E1A).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 1 ? Icons.info : Icons.info_outline,
                  size: 24,
                ),
              ),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 2
                      ? const Color(0xFFDA2E1A).withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 2 ? Icons.inventory_2 : Icons.inventory_2_outlined,
                  size: 24,
                ),
              ),
              label: 'Products',
            ),
          ],
        ),
      ),
    );
  }
}