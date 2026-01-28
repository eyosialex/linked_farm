
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
import 'package:echat/Game/ui/land_selection_screen.dart';
import 'package:echat/Vendors%20View/NotificationCenterScreen.dart';
import 'package:echat/Services/farm_persistence_service.dart';
import 'package:echat/Services/notification_service.dart';
import 'package:echat/Models/notification_model.dart';
import 'package:echat/Models/notification_model.dart';
import 'package:echat/Services/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class FarmersHomePage extends StatefulWidget {
  const FarmersHomePage({super.key});

  @override
  State<FarmersHomePage> createState() => _FarmersHomePageState();
}

class _FarmersHomePageState extends State<FarmersHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FarmPersistenceService _persistence = FarmPersistenceService();
  StreamSubscription? _notificationSubscription;
  int _lastUnreadCount = 0;
  bool _isFirstLoad = true;
  DateTime _lastNotificationTime = DateTime.now();

  List<Map<String, dynamic>> _getLocalizedMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'title': l10n.sellProduce,
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
        'title': l10n.myProducts,
        'icon': Icons.inventory,
        'image': 'assets/my_products.png',
        'page': const MyProductsScreen(),
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'title': l10n.buyInputs,
        'icon': Icons.shopping_bag,
        'image': 'assets/products.png',
        'page': const ProductListScreen(),
        'gradient': const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'title': l10n.marketPrices,
        'icon': Icons.currency_exchange,
        'image': 'assets/prices.png',
        'page': const MarketPricesPage(),
        'gradient': const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'title': l10n.messages,
        'icon': Icons.chat,
        'image': 'assets/chat.png',
        'gradient': const LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF455A64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'title': l10n.expertAdvice,
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
        'title': l10n.landPlanner,
        'icon': Icons.landscape,
        'image': 'assets/game.png',
        'page': const MyLandsScreen(),
        'gradient': const LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF303F9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _startNotificationListener();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _startNotificationListener() {
    _notificationSubscription = _persistence.streamNotifications().listen((notifications) {
      final unreadCount = notifications.where((n) => !n.isRead).length;
      
      if (_isFirstLoad) {
        _lastUnreadCount = unreadCount;
        _isFirstLoad = false;
        return;
      }

      if (unreadCount > _lastUnreadCount) {
        final now = DateTime.now();
        // Prevent notifications from firing too rapidly (at least 2 seconds apart)
        if (now.difference(_lastNotificationTime) > const Duration(seconds: 2)) {
          NotificationService.playNotificationSound();
          _lastNotificationTime = now;
        }
      }
      _lastUnreadCount = unreadCount;
    });
  }

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
    final l10n = AppLocalizations.of(context)!;
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
              title: Text(
                l10n.farmerDashboard,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              _buildLanguageSwitcher(context),
              StreamBuilder<List<AppNotification>>(
                stream: _persistence.streamNotifications(),
                builder: (context, snapshot) {
                  final notifications = snapshot.data ?? [];
                  final unreadCount = notifications.where((n) => !n.isRead).length;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationCenterScreen()),
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
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
                   Text(
                    AppLocalizations.of(context)!.welcomeBack,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.manageFarm,
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
                  final menuItems = _getLocalizedMenuItems(context);
                  return _buildMenuCard(menuItems[index], context);
                },
                childCount: _getLocalizedMenuItems(context).length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (String code) {
        localeProvider.setLocale(Locale(code));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'am',
          child: Text('አማርኛ'),
        ),
        const PopupMenuItem<String>(
          value: 'om',
          child: Text('Oromiffa'),
        ),
      ],
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
              SnackBar(content: Text(AppLocalizations.of(context)!.comingSoon(item['title']))),
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
