import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpVerificationPage extends StatefulWidget {
  final String? preFilledFcn;
  final bool useMockMode;
  
  const OtpVerificationPage({
    super.key, 
    this.preFilledFcn,
    this.useMockMode = true, // Use mock mode since API is currently broken
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _fcnController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  String _transactionId = '';
  String _resultMessage = '';
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  
  // Your API Key
  final String _apiKey = '3df53ce9f5eca342b0a8fdfe7f514ef0c39683055e5c35632977ad2bfe783f9c';

  @override
  void initState() {
    super.initState();
    if (widget.preFilledFcn != null) {
      _fcnController.text = widget.preFilledFcn!;
      print("✅ FCN pre-filled: ${widget.preFilledFcn}");
    }
  }

  // Mock OTP Function - Use this while real API is broken
  Future<void> _sendOtpMock() async {
    final fcn = _fcnController.text.trim();
    
    if (fcn.isEmpty) {
      setState(() => _resultMessage = 'Please enter Fayda Card Number');
      return;
    }
    
    if (fcn.length != 16) {
      setState(() => _resultMessage = 'FCN must be 16 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Sending OTP via Demo Mode...';
      _transactionId = '';
      _userData = null;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock transaction ID
    final mockTransactionId = 'MOCK_${DateTime.now().millisecondsSinceEpoch}';
    
    setState(() {
      _transactionId = mockTransactionId;
      _resultMessage = '✅ Demo OTP sent successfully!\n\nFor demo purposes, use OTP: 123456\n\nTransaction ID: $mockTransactionId';
    });
    
    print('✅ Mock OTP sent. Transaction ID: $mockTransactionId');
    setState(() => _isLoading = false);
  }

  // Mock OTP Verification Function
  Future<void> _verifyOtpMock() async {
    final fcn = _fcnController.text.trim();
    final otp = _otpController.text.trim();

    if (fcn.isEmpty || otp.isEmpty) {
      setState(() => _resultMessage = 'Please enter both FCN and OTP');
      return;
    }

    if (otp != '123456') {
      setState(() => _resultMessage = '❌ Invalid OTP. For demo, use: 123456');
      return;
    }

    if (_transactionId.isEmpty) {
      setState(() => _resultMessage = 'Please send OTP first');
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Verifying OTP in Demo Mode...';
    });

    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock user data
    _userData = {
      'full_name': 'Demo User',
      'birth_date': '1990-01-01',
      'gender': 'Male',
      'fcn': fcn,
      'phone_number': '+2519XXXXXXX',
      'verification_status': 'verified',
    };
    
    setState(() {
      _resultMessage = '✅ Identity verified successfully in Demo Mode!';
    });
    
    _otpController.clear();
    
    print('✅ Mock OTP Verification Successful!');
    print('📊 Mock User Data: $_userData');
    
    // Return verified data to previous screen after a short delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      print('🔄 Returning to previous screen with verified data...');
      Navigator.pop(context, _userData);
    }
    
    setState(() => _isLoading = false);
  }

  // Real API OTP Function (currently broken)
  Future<void> _sendOtpReal() async {
    final fcn = _fcnController.text.trim();
    
    if (fcn.isEmpty) {
      setState(() => _resultMessage = 'Please enter Fayda Card Number');
      return;
    }
    
    if (fcn.length != 16) {
      setState(() => _resultMessage = 'FCN must be 16 characters');
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Sending OTP...';
      _transactionId = '';
      _userData = null;
    });

    final url = Uri.parse('https://fayda-auth.vercel.app/api/fayda/otp/initiate');
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'X-API-Key': _apiKey,
    };
    final body = jsonEncode({'fcn': fcn});

    try {
      print('🔄 Sending REAL OTP request for FCN: $fcn');
      
      final response = await http.post(
        url, 
        headers: headers, 
        body: body
      ).timeout(const Duration(seconds: 30));

      final responseBody = response.body;
      
      print('📱 Raw OTP Response: $responseBody');
      print('📱 HTTP Status: ${response.statusCode}');

      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['success'] == true) {
        setState(() {
          _transactionId = jsonResponse['transactionId'] ?? '';
          _resultMessage = 'OTP sent successfully! Check your registered phone.';
        });
        
        print('✅ OTP sent successfully. Transaction ID: $_transactionId');
      } else {
        // Show server error message
        final errorMessage = jsonResponse['message'] ?? 'Failed to send OTP';
        setState(() {
          _resultMessage = '❌ Server Error: $errorMessage\n\n⚠️ Note: The verification service is currently experiencing issues. Please try demo mode.';
        });
        print('❌ OTP send failed: $errorMessage');
      }
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Connection Error: $e\n\n⚠️ Note: The verification service is currently unavailable. Please try demo mode.';
      });
      print('❌ OTP send error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Real API OTP Verification (currently broken)
  Future<void> _verifyOtpReal() async {
    final fcn = _fcnController.text.trim();
    final otp = _otpController.text.trim();

    if (fcn.isEmpty || otp.isEmpty) {
      setState(() => _resultMessage = 'Please enter both FCN and OTP');
      return;
    }

    if (otp.length != 6) {
      setState(() => _resultMessage = 'OTP must be 6 digits');
      return;
    }

    if (_transactionId.isEmpty) {
      setState(() => _resultMessage = 'Please send OTP first');
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = 'Verifying OTP...';
    });

    final url = Uri.parse('https://fayda-auth.vercel.app/api/fayda/otp/verify');
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'X-API-Key': _apiKey,
    };
    final body = jsonEncode({
      'transactionId': _transactionId,
      'otp': otp,
      'fcn': fcn,
    });

    try {
      print('🔄 Verifying REAL OTP with Transaction ID: $_transactionId');
      
      final response = await http.post(
        url, 
        headers: headers, 
        body: body
      ).timeout(const Duration(seconds: 30));

      final responseBody = response.body;
      final jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['success'] == true) {
        _userData = jsonResponse['data'] ?? jsonResponse['user'] ?? {
          'full_name': jsonResponse['fullName'],
          'birth_date': jsonResponse['birthDate'],
          'gender': jsonResponse['gender'],
          'fcn': fcn,
        };
        
        setState(() {
          _resultMessage = 'Identity verified successfully!';
        });
        
        _otpController.clear();
        
        print('✅ OTP Verification Successful!');
        print('📊 User Data: $_userData');
        
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context, _userData);
        }
      } else {
        final errorMessage = jsonResponse['message'] ?? 'OTP verification failed';
        setState(() {
          _resultMessage = '❌ Verification Failed: $errorMessage\n\n⚠️ Note: The verification service is currently experiencing issues. Please try demo mode.';
        });
        print('❌ OTP verification failed: $errorMessage');
      }
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Verification Error: $e\n\n⚠️ Note: The verification service is currently unavailable. Please try demo mode.';
      });
      print('❌ OTP verification error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Main OTP function that chooses between mock and real
  Future<void> _sendOtp() async {
    if (widget.useMockMode) {
      await _sendOtpMock();
    } else {
      await _sendOtpReal();
    }
  }

  // Main verification function that chooses between mock and real
  Future<void> _verifyOtp() async {
    if (widget.useMockMode) {
      await _verifyOtpMock();
    } else {
      await _verifyOtpReal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('National ID Verification'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // Demo mode indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.useMockMode ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.useMockMode ? 'DEMO MODE' : 'LIVE MODE',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header with mode information
            Card(
              color: widget.useMockMode ? Colors.orange[50] : Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.useMockMode ? Icons.developer_mode : Icons.verified_user,
                          color: widget.useMockMode ? Colors.orange : Colors.blue[700],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.useMockMode ? "Demo Verification" : "Verify Your Identity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.useMockMode ? Colors.orange[800] : Colors.blue[800],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.useMockMode 
                                    ? "Using demo mode while service is being fixed"
                                    : "Enter your 16-character Fayda Card Number",
                                style: TextStyle(
                                  color: widget.useMockMode ? Colors.orange[600] : Colors.blue[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.useMockMode) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Demo OTP: 123456",
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // FCN Input
            TextField(
              controller: _fcnController,
              decoration: const InputDecoration(
                labelText: 'Fayda Card Number (FCN)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
                hintText: 'Enter 16-character FCN',
                helperText: 'Enter exactly 16 characters',
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              maxLength: 16,
            ),
            
            const SizedBox(height: 10),
            
            // Send OTP Button
            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.useMockMode ? Colors.orange : Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.useMockMode ? Icons.developer_mode : Icons.send),
                        const SizedBox(width: 8),
                        Text(widget.useMockMode ? 'Send Demo OTP' : 'Send OTP'),
                      ],
                    ),
            ),
            
            const SizedBox(height: 20),
            
            // OTP Input
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.sms),
                hintText: widget.useMockMode ? 'Use: 123456' : 'Enter 6-digit OTP',
                helperText: widget.useMockMode ? 'Demo OTP: 123456' : 'Enter the OTP sent to your phone',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            
            const SizedBox(height: 10),
            
            // Verify OTP Button
            ElevatedButton(
              onPressed: (_isLoading || _transactionId.isEmpty) ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: _transactionId.isEmpty ? Colors.grey : 
                               widget.useMockMode ? Colors.orange : Colors.green[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.useMockMode ? Icons.developer_mode : Icons.verified),
                        const SizedBox(width: 8),
                        Text(widget.useMockMode ? 'Verify Demo OTP' : 'Verify OTP'),
                      ],
                    ),
            ),
            
            const SizedBox(height: 20),
            
            // Result Message
            if (_resultMessage.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _resultMessage.contains('✅') 
                      ? Colors.green[50] 
                      : _resultMessage.contains('❌') 
                        ? Colors.red[50]
                        : _resultMessage.contains('Demo') 
                          ? Colors.orange[50]
                          : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _resultMessage.contains('✅') 
                        ? Colors.green 
                        : _resultMessage.contains('❌') 
                          ? Colors.red
                          : _resultMessage.contains('Demo') 
                            ? Colors.orange
                            : Colors.blue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _resultMessage.contains('✅') 
                          ? Icons.check_circle 
                          : _resultMessage.contains('❌') 
                            ? Icons.error
                            : _resultMessage.contains('Demo') 
                              ? Icons.developer_mode
                              : Icons.info,
                      color: _resultMessage.contains('✅') 
                          ? Colors.green 
                          : _resultMessage.contains('❌') 
                            ? Colors.red
                            : _resultMessage.contains('Demo') 
                              ? Colors.orange
                              : Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _resultMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: _resultMessage.contains('✅') 
                              ? Colors.green[800] 
                              : _resultMessage.contains('❌') 
                                ? Colors.red[800]
                                : _resultMessage.contains('Demo') 
                                  ? Colors.orange[800]
                                  : Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            
            // Transaction ID
            if (_transactionId.isNotEmpty) ...[
              Card(
                color: Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Transaction ID: $_transactionId',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Service Status Indicator
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      widget.useMockMode ? Icons.developer_mode : Icons.warning,
                      color: widget.useMockMode ? Colors.orange : Colors.blue[600],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.useMockMode 
                            ? 'Using demo mode. Real service will be enabled when fixed.'
                            : 'Note: Verification service may experience temporary outages',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Switch between demo and real mode
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Demo Mode:'),
                const SizedBox(width: 10),
                Switch(
                  value: widget.useMockMode,
                  onChanged: (value) {
                    // You can implement mode switching here if needed
                  },
                  activeColor: Colors.orange,
                ),
                Text(
                  widget.useMockMode ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: widget.useMockMode ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.bold,
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