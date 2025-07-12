import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> registeredUsers = {}; // {phone: password}
Map<String, String> userNames = {}; // {phone: name}

void main() => runApp(const PayUPIApp());

class PayUPIApp extends StatelessWidget {
  const PayUPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayUPI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // 👈 starts here
    );
  }
}

// 1. Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegistrationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animations/newlogo.json', // ✅ Make sure this file exists and is listed in pubspec.yaml
          width: 500,
          height: 500,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              "🚫 LOGO.png not found",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}

// 2. Registration Page (After Splash)
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  void handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.length != 10 ||
        password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);

    // Save registration info locally for login match
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reg_name', name);
    await prefs.setString('reg_password', password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "📝 Register",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Lottie.asset('assets/animations/newlogo.json', height: 150),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Color.fromARGB(150, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password (Min 4 chars)',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _resetController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🔐 Forgot Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Enter your registered name to reset password",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _resetController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final registeredName = prefs.getString('reg_name') ?? '';
                final registeredPassword =
                    prefs.getString('reg_password') ?? '';

                if (_resetController.text.trim() == registeredName) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Your password is: $registeredPassword"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name not found!")),
                  );
                }
              },
              child: const Text("Get Password"),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleLogin() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || phone.length != 10 || password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid name, 10-digit phone, and password (min 4 chars)",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => KYCPage(userName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/loading1.json', height: 180),
                  const SizedBox(height: 16),
                  const Text(
                    "Login to PayUPI",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter at least 4 characters',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: 'Enter your 10-digit number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ✅ Your "Don't have an account?" row placed correctly here
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrationPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}

// 4. KYC Verification
class KYCPage extends StatefulWidget {
  final String userName;
  const KYCPage({super.key, required this.userName});

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  bool isLoading = false;

  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  void verifyKYC() async {
    final aadhaar = _aadhaarController.text.trim();
    final pan = _panController.text.trim();

    if (aadhaar.length != 12 ||
        !RegExp(r'^\d{12}$').hasMatch(aadhaar) ||
        !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid Aadhaar and PAN numbers.")),
      );
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MPINSetupPage(userName: widget.userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🔐 KYC Verification',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Enter your KYC details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _aadhaarController,
                  decoration: InputDecoration(
                    labelText: 'Aadhaar Number',
                    hintText: 'XXXX XXXX XXXX',
                    prefixIcon: const Icon(Icons.credit_card),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _panController,
                  decoration: InputDecoration(
                    labelText: 'PAN Number',
                    hintText: 'ABCDE1234F',
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyKYC,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Verify KYC",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}

// 5. MPIN Setup
class MPINSetupPage extends StatefulWidget {
  final String userName;
  const MPINSetupPage({super.key, required this.userName});

  @override
  State<MPINSetupPage> createState() => _MPINSetupPageState();
}

class _MPINSetupPageState extends State<MPINSetupPage> {
  bool isLoading = false;
  final TextEditingController _mpinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  void handleMPIN() async {
    final mpin = _mpinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (mpin.length != 4 || confirm.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("MPIN must be exactly 4 digits")),
      );
      return;
    }

    if (mpin != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("MPINs do not match")));
      return;
    }

    // ✅ Save MPIN
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_mpin', mpin);

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BankSelectionPage(userName: widget.userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          '🔒 MPIN Setup',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Secure your app with a 4-digit MPIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _mpinController,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter MPIN',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Confirm MPIN',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleMPIN,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Set MPIN",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            ),
        ],
      ),
    );
  }
}

// 6. Bank Selection
class BankSelectionPage extends StatelessWidget {
  final String userName;
  const BankSelectionPage({super.key, required this.userName});

  final List<Map<String, String>> banks = const [
    {
      'name': 'State Bank of India (SBI)',
      'subtitle': 'India’s largest bank',
      'icon': 'assets/banks/sbi.png',
    },
    {
      'name': 'HDFC Bank',
      'subtitle': 'Trusted private sector bank',
      'icon': 'assets/banks/hdfc.png',
    },
    {
      'name': 'ICICI Bank',
      'subtitle': 'Innovative digital banking',
      'icon': 'assets/banks/icici.png',
    },
    {
      'name': 'Axis Bank',
      'subtitle': 'Reliable financial services',
      'icon': 'assets/banks/axis.png',
    },
    {
      'name': 'Kotak Mahindra Bank',
      'subtitle': 'Modern banking solutions',
      'icon': 'assets/banks/kotak.png',
    },
    {
      'name': 'Bank of Baroda',
      'subtitle': 'Public sector banking leader',
      'icon': 'assets/banks/bob.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          '🏦 Select Bank',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: banks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final bank = banks[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  bank['icon']!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Text(
                          bank['name']![0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                ),
              ),
              title: Text(
                bank['name']!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(bank['subtitle']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UPIIDPage(userName: userName),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 7. UPI ID Creation
class UPIIDPage extends StatefulWidget {
  final String userName;
  const UPIIDPage({super.key, required this.userName});

  @override
  State<UPIIDPage> createState() => _UPIIDPageState();
}

class _UPIIDPageState extends State<UPIIDPage> {
  final TextEditingController _upiController = TextEditingController();
  String _selectedSuffix = '@payupi';

  final List<String> suffixes = ['@payupi', '@upi', '@bank'];

  void _createUPI(BuildContext context) {
    final enteredID = _upiController.text.trim();

    if (enteredID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid UPI ID")),
      );
      return;
    }

    final fullUPI = '$enteredID$_selectedSuffix';
    // You can store or use fullUPI here

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(userName: widget.userName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          '💳 Create UPI ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Choose your UPI ID",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _upiController,
                    decoration: InputDecoration(
                      labelText: 'Enter ID prefix',
                      hintText: 'e.g. yourname123',
                      prefixIcon: const Icon(Icons.alternate_email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedSuffix,
                  items:
                      suffixes
                          .map(
                            (suffix) => DropdownMenuItem(
                              value: suffix,
                              child: Text(suffix),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSuffix = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _createUPI(context),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  "Create UPI ID",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Home Page
class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'icon': LucideIcons.send,
        'label': 'Send',
        'page': SendMoneyPage(userName: userName),
        'color': Colors.blueAccent,
      },
      {
        'icon': LucideIcons.qrCode,
        'label': 'Personal QR',
        'page': PersonalQR(),
        'color': Colors.orange,
      },
      {
        'icon': LucideIcons.history,
        'label': 'History',
        'page': const TransactionHistoryPage(),
        'color': Colors.purple,
      },
      {
        'icon': LucideIcons.wallet,
        'label': 'Wallet',
        'page': WalletPage(userName: userName),
        'color': Colors.indigo,
      },
      {
        'icon': LucideIcons.settings,
        'label': 'Settings',
        'page': SettingsPage(),
        'color': Colors.brown,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          '🏠 Home Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Successfully Logged Out!")),
                );
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $userName 👋",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Welcome back to PayUPI",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.card_giftcard, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Refer friends & earn ₹50!",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children:
                  features.map((item) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.95, end: 1.0),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: Material(
                            color: Colors.white,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              splashColor: item['color'].withOpacity(0.2),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => item['page'],
                                  ),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: item['color'].withOpacity(0.4),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item['icon'],
                                      size: 28,
                                      color: item['color'],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['label'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

//Helper Widget for Transactions
Widget _buildTransactionItem(String name, String amount, String type) {
  final isReceived = amount.startsWith('+');
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: isReceived ? Colors.green : Colors.red,
          child: Icon(
            isReceived ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(type, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isReceived ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

// 9. Send Money Page
class SendMoneyPage extends StatelessWidget {
  final String userName;
  const SendMoneyPage({super.key, required this.userName});
  final List<Map<String, String>> recentChats = const [
    {'name': 'Rahul', 'phone': '9876543210'},
    {'name': 'Sneha', 'phone': '9123456789'},
    {'name': 'Aman', 'phone': '9988776655'},
  ];

  void _openPhoneNumberPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhoneNumberPaymentPage(userName: userName),
      ),
    );
  }

  void _openContactsPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactsPaymentPage(userName: userName),
      ),
    );
  }

  void _openQRPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QRPaymentPage(userName: userName)),
    );
  }

  void _openChat(BuildContext context, String name, String phone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatWithUserPage(userName: name, userPhone: phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('💸 Send Money'),
      backgroundColor: Colors.deepPurple,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send via',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ActionChip(
                label: const Text('📱 Phone Number'),
                onPressed: () => _openPhoneNumberPayment(context),
              ),
              ActionChip(
                label: const Text('👥 Contacts'),
                onPressed: () => _openContactsPayment(context),
              ),
              ActionChip(
                label: const Text('📷 QR Code'),
                onPressed: () => _openQRPayment(context),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Recent Chats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: recentChats.length,
              itemBuilder: (context, index) {
                final user = recentChats[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(user['name']!),
                  subtitle: Text(user['phone']!),
                  trailing: const Icon(Icons.chat),
                  onTap:
                      () => _openChat(context, user['name']!, user['phone']!),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

// 10. Send via Phone
class PhoneNumberPaymentPage extends StatefulWidget {
  final String userName;
  const PhoneNumberPaymentPage({super.key, required this.userName});

  @override
  State<PhoneNumberPaymentPage> createState() => _PhoneNumberPaymentPageState();
}

class _PhoneNumberPaymentPageState extends State<PhoneNumberPaymentPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _confirmPayment() {
    final phone = _phoneController.text.trim();
    final amount = _amountController.text.trim();

    if (phone.length != 10 || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid phone and amount')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentSuccessPage(
              recipient: 'Phone: $phone',
              amount: amount,
              userName: widget.userName,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📱 Pay via Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Enter 10-digit Mobile Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Enter Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _confirmPayment,
              icon: const Icon(Icons.send),
              label: const Text("Send Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

// 11. Send via Contacts
class ContactsPaymentPage extends StatelessWidget {
  final String userName;
  const ContactsPaymentPage({super.key, required this.userName});

  final List<String> dummyContacts = const [
    "Aarav Kumar",
    "Priya Sharma",
    "Rahul Verma",
    "Sneha Singh",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("👥 Pay via Contacts")),
      body: ListView.builder(
        itemCount: dummyContacts.length,
        itemBuilder: (context, index) {
          final name = dummyContacts[index];
          return ListTile(
            title: Text(name),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => AmountInputPage(
                        contactName: name,
                        userName: userName,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 12. Amount Input Page
class AmountInputPage extends StatefulWidget {
  final String contactName;
  final String userName;
  const AmountInputPage({
    super.key,
    required this.contactName,
    required this.userName,
  });

  @override
  State<AmountInputPage> createState() => _AmountInputPageState();
}

class _AmountInputPageState extends State<AmountInputPage> {
  final TextEditingController _amountController = TextEditingController();

  void _sendPayment() {
    final amount = _amountController.text.trim();
    if (amount.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaymentSuccessPage(
              recipient: widget.contactName,
              amount: amount,
              userName: widget.userName,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pay to ${widget.contactName}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _sendPayment,
              icon: const Icon(Icons.check),
              label: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

// 13. QR Payment Page
class QRPaymentPage extends StatelessWidget {
  final String userName;
  const QRPaymentPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📷 Scan QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 100),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AmountInputPage(
                          contactName: "Scanned UPI",
                          userName: "User",
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text("Scan & Pay"),
            ),
          ],
        ),
      ),
    );
  }
}

// 14. Payment Success Page
class PaymentSuccessPage extends StatelessWidget {
  final String recipient;
  final String amount;
  final String userName;

  const PaymentSuccessPage({
    super.key,
    required this.recipient,
    required this.amount,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("✅ Payment Success")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              height: 180,
              repeat: false,
            ),
            const SizedBox(height: 20),
            Text(
              "₹$amount sent to",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(recipient, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(userName: userName),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}

// 15. Chat with User Page
class ChatWithUserPage extends StatefulWidget {
  final String userName;
  final String userPhone;
  const ChatWithUserPage({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  State<ChatWithUserPage> createState() => _ChatWithUserPageState();
}

class _ChatWithUserPageState extends State<ChatWithUserPage> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add("You: $text");
        _controller.clear();
      });
    }
  }

  void sendMoney() {
    final amount = _amountController.text.trim();
    if (amount.isNotEmpty && double.tryParse(amount) != null) {
      _amountController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PaymentSuccessPage(
                recipient: widget.userName,
                amount: amount,
                userName: widget.userName,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💬 Chat with ${widget.userName}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder:
                  (context, index) => Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(messages[index]),
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter amount to send',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMoney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    'Send ₹',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 16. Personal QR Code Page
class PersonalQR extends StatelessWidget {
  const PersonalQR({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📷 My QR Code"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan this QR to pay me!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/qr.png', width: 500, height: 500),
          ],
        ),
      ),
    );
  }
}

/// 18. Wallet Page
class WalletPage extends StatefulWidget {
  final String userName;
  const WalletPage({super.key, required this.userName});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _mpinController = TextEditingController();
  String? balance;
  bool isUnlocked = false;

  Future<void> unlockWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMpin = prefs.getString('user_mpin') ?? '';

    if (_mpinController.text.trim() == savedMpin) {
      setState(() {
        isUnlocked = true;
        balance = '₹12,480.00'; // This can be dynamic later
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Incorrect MPIN")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💼 Wallet"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child:
            isUnlocked
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      balance ?? "",
                      style: const TextStyle(fontSize: 32, color: Colors.green),
                    ),
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 60, color: Colors.grey),
                      const SizedBox(height: 20),
                      const Text(
                        "Enter MPIN to Unlock Wallet",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _mpinController,
                        obscureText: true,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                          labelText: 'MPIN',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: unlockWallet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text(
                          "Unlock",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

/// 19. Transaction History Page
class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  final List<Map<String, dynamic>> transactions = const [
    {'name': 'Ajay', 'type': 'Sent', 'amount': 500.0, 'date': 'July 4, 2025'},
    {
      'name': 'Aarav Kumar',
      'type': 'Sent',
      'amount': 1200.0,
      'date': 'July 3, 2025',
    },
    {
      'name': 'Priya Sharma',
      'type': 'Received',
      'amount': 500.0,
      'date': 'July 3, 2025',
    },
    {
      'name': 'Sneha Singh',
      'type': 'Sent',
      'amount': 250.0,
      'date': 'July 1, 2025',
    },
    {
      'name': 'Rahul Verma',
      'type': 'Received',
      'amount': 1000.0,
      'date': 'June 30, 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📜 Transaction History"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          final isReceived = txn['type'] == 'Received';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isReceived ? Colors.green.shade100 : Colors.red.shade100,
                  child: Icon(
                    isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isReceived ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txn['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        txn['date'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${isReceived ? '+' : '-'} ₹${txn['amount']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isReceived ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 20. Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "⚙️ Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("🔐 Security"),
          _buildTile(
            context,
            icon: Icons.lock,
            title: "Change MPIN",
            subtitle: "Update your 4-digit MPIN for enhanced security",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.fingerprint,
            title: "Biometric Authentication",
            subtitle: "Enable/Disable fingerprint unlock",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("💳 Bank & UPI"),
          _buildTile(
            context,
            icon: Icons.account_balance,
            title: "Linked Bank Accounts",
            subtitle: "Manage or change your linked banks",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.account_circle,
            title: "UPI ID",
            subtitle: "View or edit your UPI ID",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("🔔 Notifications & Preferences"),
          _buildTile(
            context,
            icon: Icons.notifications_active,
            title: "Transaction Alerts",
            subtitle: "Enable/Disable payment alerts",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.language,
            title: "App Language",
            subtitle: "Select your preferred language",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("📜 History & Logs"),
          _buildTile(
            context,
            icon: Icons.receipt_long,
            title: "Transaction History",
            subtitle: "See all your past payments",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.delete_forever,
            title: "Clear History",
            subtitle: "Delete transaction records from this device",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("📞 Support"),
          _buildTile(
            context,
            icon: Icons.help_outline,
            title: "Help Center",
            subtitle: "Frequently asked questions",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.support_agent,
            title: "Contact Support",
            subtitle: "Chat, email or call support",
            onTap: () {},
          ),

          const Divider(),
          _buildSectionHeader("ℹ️ About"),
          _buildTile(
            context,
            icon: Icons.info_outline,
            title: "About PayUPI",
            subtitle: "App version, terms, and privacy policy",
            onTap: () {},
          ),
          _buildTile(
            context,
            icon: Icons.star_rate,
            title: "Rate Us",
            subtitle: "Share your feedback on the app store",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
