
import 'package:echat/Dlivery%20View/list_deliveryavailable.dart';
import 'package:echat/Farmers%20View/Enter_Sell_Item.dart';
import 'package:echat/Vendors%20View/product.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/User%20Credential/log_in_page.dart';
import 'package:echat/Farmers%20View/Market_Prices.dart';
import 'package:echat/Farmers%20View/My_Products.dart';
import 'package:echat/Farmers%20View/advice_feed.dart';
import 'package:echat/Chat/chat_list.dart';
import 'package:echat/Game/ui/game_dashboard.dart';

class FarmersHomePage extends StatefulWidget {
  const FarmersHomePage({super.key});

  @override
  State<FarmersHomePage> createState() => _FarmersHomePageState();
}

class _FarmersHomePageState extends State<FarmersHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Sell Produce',
      'icon': Icons.sell,
      'image': 'assets/sell_item.jpg',
      'page': SellItem(),
      'gradient': const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'My Products',
      'icon': Icons.inventory,
      'image': 'assets/my_products.png', // You might need to ensure this asset exists or reuse another
      'page': const MyProductsScreen(),
      'gradient': const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Buy Inputs',
      'icon': Icons.shopping_bag, // Pesticides, fertilizers etc.
      'image': 'assets/products.png', 
      'page': const ProductListScreen(), // Link to Vendors/Products
      'gradient': const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Market Prices',
      'icon': Icons.currency_exchange,
      'image': 'assets/prices.png',
      'page': const MarketPricesPage(), // Link to Market Prices
      'gradient': const LinearGradient(
        colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Messages',
      'icon': Icons.chat,
      'image': 'assets/chat.png',
      'page': const ChatListScreen(),
      'gradient': const LinearGradient(
        colors: [Color(0xFF607D8B), Color(0xFF455A64)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Delivery Services',
      'icon': Icons.local_shipping,
      'image': 'assets/delivery.png',
      'page': availabledriverylist(),
      'gradient': const LinearGradient(
        colors: [Color(0xFF00BCD4), Color(0xFF00838F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Expert Advice',
      'icon': Icons.school,
      'image': 'assets/advice.png',
      'page': const AdviceFeedScreen(),
      'gradient': const LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Virtual Farming Game',
      'icon': Icons.videogame_asset,
      'image': 'assets/game.png',
      'page': const GameDashboard(),
      'gradient': const LinearGradient(
        colors: [Color(0xFF3F51B5), Color(0xFF303F9F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  void _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LogInPage(onTap: null)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.green[700],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/farm_header.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.green[800]);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                "Farmer Dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: _logout,
              ),
            ],
          ),

          // Welcome Message
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Manage your farm and crops efficiently.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid Menu
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildMenuCard(_menuItems[index], context);
                },
                childCount: _menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (item['page'] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['page']),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item['title']} coming soon!")),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: item['gradient'],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], size: 32, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                item['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
