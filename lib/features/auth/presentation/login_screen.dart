import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _handleGetOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Generate Mock OTP (replicating RN logic)
    final otp = (100000 + Random().nextInt(900000)).toString();
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // Show OTP Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('OTP Generated'),
          content: Text('Your OTP is: $otp\n\n(In production, this would be sent via SMS)'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/otp', extra: {'phone': phone, 'otp': otp});
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              
              // Header actions
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    if (kIsWeb) {
                      context.go('/');
                    } else {
                      context.go('/home');
                    }
                  },
                  child: const Text('Skip'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Illustration Placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cleaning_services,
                  size: 80,
                  color: AppTheme.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue booking expert services',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 48),
              
              // Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'MOBILE NUMBER',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: '98765 43210',
                        prefixIcon: Icon(Icons.phone_outlined),
                        counterText: "",
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleGetOtp,
                      child: _isLoading 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          )
                        : const Text('Get OTP'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
