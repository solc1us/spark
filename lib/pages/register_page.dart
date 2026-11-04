import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String nameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  bool validateName() {
    String name = _nameController.text;

    if (name == '') {
      nameError = 'Nama lengkap wajib diisi';
      return false;
    } else {
      nameError = '';
      return true;
    }
  }

  bool validateEmail() {
    String email = _emailController.text;

    if (email == '') {
      emailError = 'Email wajib diisi';
      return false;
    } else if (!email.contains('@') || !email.contains('.')) {
      emailError = 'Format email tidak valid';
      return false;
    } else {
      emailError = '';
      return true;
    }
  }

  bool validatePassword() {
    String password = _passwordController.text;

    if (password == '') {
      passwordError = 'Password wajib diisi';
      return false;
    } else if (password.length < 4) {
      passwordError = 'Password minimal 4 karakter';
      return false;
    } else {
      passwordError = '';
      return true;
    }
  }

  bool validateConfirmPassword() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (confirmPassword == '') {
      confirmPasswordError = 'Konfirmasi password wajib diisi';
      return false;
    } else if (confirmPassword != password) {
      confirmPasswordError = 'Konfirmasi password tidak sama';
      return false;
    } else {
      confirmPasswordError = '';
      return true;
    }
  }

  void _register() {
    bool nameValid = validateName();
    bool emailValid = validateEmail();
    bool passwordValid = validatePassword();
    bool confirmPasswordValid = validateConfirmPassword();

    setState(() {});

    if (nameValid && emailValid && passwordValid && confirmPasswordValid) {
      bool success = context.read<AppState>().register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil. Silakan login.')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran gagal. Periksa data akun.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'SPARK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFEA580C),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Spot My Park',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
              ),

              const SizedBox(height: 36),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buat akun baru',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Daftar untuk mulai menyimpan dan menemukan lokasi parkirmu.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama lengkap',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEA580C),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (nameError != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          nameError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    const Text(
                      'Email',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Masukkan email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEA580C),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (emailError != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          emailError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEA580C),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (passwordError != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          passwordError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    const Text(
                      'Konfirmasi Password',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEA580C),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (confirmPasswordError != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          confirmPasswordError,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEA580C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: Text(
                            'Sudah punya akun?',
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Masuk sekarang',
                            style: TextStyle(
                              color: Color(0xFFEA580C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
