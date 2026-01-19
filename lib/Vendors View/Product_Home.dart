import 'package:flutter/material.dart';

class vendors_page extends StatefulWidget {
  const vendors_page({super.key});
  @override
  State<vendors_page> createState() => _vendors_pageState();
}

class _vendors_pageState extends State<vendors_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Page"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: const [
            DrawerHeader(child: Text("Drawer")),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          children: const [
            vendors_grid(
              title: "sell",
              icon: Icons.agriculture,
              page: Placeholder(),
            ),
            vendors_grid(
              title: "Buy",
              icon: Icons.shopping_cart,
              page: Placeholder(),
            ),
            vendors_grid(
              title: "Yours",
              icon: Icons.local_shipping,
              page: Placeholder(),
            ),
            vendors_grid(
              title: "Today",
              icon: Icons.support_agent,
              page: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}
class vendors_grid extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;

  const vendors_grid({
    super.key,
    required this.title,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
