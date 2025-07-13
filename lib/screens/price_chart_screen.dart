import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PriceChartScreen extends StatefulWidget {
  const PriceChartScreen({Key? key}) : super(key: key);

  @override
  State<PriceChartScreen> createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends State<PriceChartScreen> {
  List<dynamic> _items = [];
  String _category = '';
  bool _isLoading = true;
  int _currentIndex = 0; // For bottom nav highlight

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Map) {
      _category = args['title'] ?? '';
      _currentIndex = args['currentIndex'] ?? 0;
      if (_category.isNotEmpty) {
        _loadData();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category not found.')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final String data = await rootBundle.loadString('assets/price_data.json');
      final Map<String, dynamic> jsonResult = json.decode(data);
      setState(() {
        _items = jsonResult[_category] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _items = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data for $_category.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFDA2E1A);
    final accentColor = const Color(0xFFF5F5F5);
    final textColor = const Color(0xFF1A202C);

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          _category.isNotEmpty ? _category : 'Price Chart',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDA2E1A)))
          : _items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No price data available${_category.isNotEmpty ? ' for $_category.' : '.'}',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 4,
                              child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('Min Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white), textAlign: TextAlign.right),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white), textAlign: TextAlign.right),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Data Rows
                      Expanded(
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final isEven = index % 2 == 0;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isEven ? Colors.white : accentColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(item['name'] ?? '', style: TextStyle(fontSize: 15, color: textColor)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['min_qty'] != null ? '${item['min_qty']}' : '',
                                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['price'] != null ? item['price'] : '',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
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
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
            } else if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(context, '/about', (_) => false);
            } else if (index == 2) {
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (_) => false);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? const Color(0xFFDA2E1A).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined, size: 24),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? const Color(0xFFDA2E1A).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_currentIndex == 1 ? Icons.info : Icons.info_outline, size: 24),
              ),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? const Color(0xFFDA2E1A).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_currentIndex == 2 ? Icons.inventory_2 : Icons.inventory_2_outlined, size: 24),
              ),
              label: 'Products',
            ),
          ],
        ),
      ),
    );
  }
}
