import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
class CropAdvice extends StatefulWidget {
  const CropAdvice({super.key});
  @override
  State<CropAdvice> createState() => _CropAdviceState();
}
class _CropAdviceState extends State<CropAdvice> {
  final List<Map<String, String>> crops = const [
    {'name': 'Maize', 'file': 'assets/crops html/maiz.html'}, 
    {'name': 'Teff', 'file': 'assets/crops html/teff.html'},   
    {'name': 'Wheat', 'file': 'assets/crops html/wheat.html'}, 
    {'name': 'Onion', 'file': 'assets/crops html/onion.html'}, 
    {'name': 'Tomato', 'file': 'assets/crops html/tomato.html'}, 
  ];
  List<Map<String, String>> filteredCrops = [];

  @override
  void initState() {
    filteredCrops = crops;
    super.initState();
  }
  void searchCrops(String query) {
    setState(() {
      filteredCrops = crops.where((crop) {
        return crop['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Advice'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '🔍 Search crops...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: searchCrops,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCrops.length,
              itemBuilder: (context, index) {
                final crop = filteredCrops[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.eco, color: Colors.green[700]),
                    ),
                    title: Text(
                      crop['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text('Tap to read complete guide'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropDetailPage(
                            cropName: crop['name']!,
                            htmlFilePath: crop['file']!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CropDetailPage extends StatefulWidget {
  final String cropName;
  final String htmlFilePath;

  const CropDetailPage({
    super.key,
    required this.cropName,
    required this.htmlFilePath,
  });

  @override
  State<CropDetailPage> createState() => _CropDetailPageState();
}

class _CropDetailPageState extends State<CropDetailPage> {
  WebViewController? controller;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  Future<void> _loadHtmlContent() async {
    try {
      final htmlContent = await rootBundle.loadString(widget.htmlFilePath);
      
      setState(() {
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
              
              },
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          )
          ..loadHtmlString(htmlContent);
      });
    } catch (e) {
      print('Error loading HTML: $e');
      final errorHtml = '''
        <html>
          <body style="font-family: Arial; padding: 20px; text-align: center;">
            <h2 style="color: #d32f2f;">Content Not Available</h2>
            <p>Information for ${widget.cropName} is coming soon!</p>
            <p>Check back later for comprehensive growing guide.</p>
            <p>Error: $e</p>
          </body>
        </html>
      ''';
      
      setState(() {
        controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(errorHtml)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cropName),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          if (isLoading)
            const Padding(
             padding: EdgeInsets.all(1.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: controller == null 
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller!), // Fixed this line
    );
  }
}