import 'package:cloud_user/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:cloud_user/features/profile/presentation/providers/user_provider.dart';
import 'package:cloud_user/core/theme/app_theme.dart';
import 'package:cloud_user/features/auth/data/auth_repository.dart';
import 'package:cloud_user/features/web/presentation/web_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int _currentStep = 1;
  bool _isLoading = false;

  // Step 2 Data
  User? _firebaseUser;
  final _nameController = TextEditingController();
  String? _profileImageUrl;
  String? _base64Image;

  // Step 3 Data
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final credential = await ref
          .read(authRepositoryProvider)
          .signInWithGoogle();
      if (credential != null && credential.user != null) {
        setState(() {
          _firebaseUser = credential.user;
          _nameController.text = _firebaseUser!.displayName ?? '';
          _profileImageUrl = _firebaseUser!.photoURL;
          _currentStep = 2;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCompleteRegistration() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid mobile number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .completeRegistration(
            uid: _firebaseUser!.uid,
            name: _nameController.text,
            email: _firebaseUser!.email!,
            phone: _phoneController.text,
            password: _passwordController.text,
            profileImage: _base64Image ?? _profileImageUrl,
          );

      if (mounted) {
        ref.invalidate(authStateProvider);
        ref.invalidate(userProfileProvider);
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    Widget content = Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? 500 : double.infinity,
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStepIndicator(),
            const SizedBox(height: 48),
            _buildStepContent(),
          ],
        ),
      ),
    );

    if (kIsWeb) {
      return WebLayout(child: content);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: SingleChildScrollView(child: content)),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepCircle(1, 'Identify'),
        _stepLine(1),
        _stepCircle(2, 'Profile'),
        _stepLine(2),
        _stepCircle(3, 'Security'),
      ],
    );
  }

  Widget _stepCircle(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isActive ? AppTheme.primary : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(int step) {
    bool isActive = _currentStep > step;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
      color: isActive ? AppTheme.primary : Colors.grey.shade200,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Text(
          'Join Cloud Wash',
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Fastest way to get expert laundry services.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.g_mobiledata,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
            label: Text(
              'Sign up with Google',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: _base64Image != null
                  ? MemoryImage(base64Decode(_base64Image!.split(',').last))
                        as ImageProvider
                  : (_profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null),
              child: (_base64Image == null && _profileImageUrl == null)
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            InkWell(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Setup Profile',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildTextField('Full Name', _nameController, Icons.person_outline),
        const SizedBox(height: 20),
        _buildTextField(
          'Email Address',
          TextEditingController(text: _firebaseUser?.email),
          Icons.email_outlined,
          enabled: false,
        ),
        const SizedBox(height: 40),
        _primaryButton('Continue', () => setState(() => _currentStep = 3)),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Text(
          'Security & Contact',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildTextField(
          'Mobile Number',
          _phoneController,
          Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          'Create Password',
          _passwordController,
          Icons.lock_outline,
          isPassword: true,
          obscureText: !_showPassword,
          onSuffixIconTap: () => setState(() => _showPassword = !_showPassword),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          'Confirm Password',
          _confirmPasswordController,
          Icons.lock_outline,
          isPassword: true,
          obscureText: !_showConfirmPassword,
          onSuffixIconTap: () =>
              setState(() => _showConfirmPassword = !_showConfirmPassword),
        ),
        const SizedBox(height: 40),
        _primaryButton('Register Now', _handleCompleteRegistration),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onSuffixIconTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
