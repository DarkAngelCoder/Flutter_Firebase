import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();

  bool rememberMe = false;
  bool acceptTerms = false;

  Future<void> _signIn() async {
    if (_formKeyLogin.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmailController.text.trim(),
          password: _loginPasswordController.text.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no login: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKeySignup.currentState!.validate() && acceptTerms) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _signupEmailController.text.trim(),
          password: _signupPasswordController.text.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no cadastro: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.deepPurple,
                    indicator: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    tabs: [Tab(text: 'Sign in'), Tab(text: 'Sign up')],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 350,
                    child: TabBarView(
                      children: [
                        // LOGIN FORM
                        Form(
                          key: _formKeyLogin,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _loginEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Email obrigatório'
                                            : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _loginPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.length < 6
                                            ? 'Senha deve ter pelo menos 6 caracteres'
                                            : null,
                              ),
                              const SizedBox(height: 8),
                              CheckboxListTile(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                                title: const Text('Remember password'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _signIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SIGNUP FORM
                        Form(
                          key: _formKeySignup,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _signupEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Email obrigatório'
                                            : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _signupPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value!.length < 6
                                            ? 'Senha muito curta'
                                            : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _signupConfirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(),
                                ),
                                validator:
                                    (value) =>
                                        value != _signupPasswordController.text
                                            ? 'Senhas não coincidem'
                                            : null,
                              ),
                              CheckboxListTile(
                                value: acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    acceptTerms = value!;
                                  });
                                },
                                title: const Text('Accept Terms'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _signUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
