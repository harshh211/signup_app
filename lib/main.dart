import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedAvatar = '😊';

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
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              
              const Text('Pick your avatar:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['😊', '🎯', '🔥', '👾'].map((emoji) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = emoji),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedAvatar == emoji
                              ? Colors.purple
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Welcome! Account created successfully.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(
                            name: _nameController.text,
                            avatar: _selectedAvatar,
                          ),
                        ),
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const WelcomeScreen({super.key, required this.name, required this.avatar});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Welcome!'),
      ),
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.avatar, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${widget.name}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your account has been created.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}