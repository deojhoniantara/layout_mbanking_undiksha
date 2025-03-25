import 'package:flutter/material.dart';
import 'package:flutter_application_1/deposito.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/mutasi.dart';
import 'package:flutter_application_1/pengaturan.dart';
import 'package:flutter_application_1/provider/nasabah_provider.dart';
import 'package:flutter_application_1/pembayaran.dart';
import 'package:flutter_application_1/pinjaman.dart';
import 'package:flutter_application_1/profil.dart';
import 'package:flutter_application_1/saldo.dart';
import 'package:flutter_application_1/transfer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 21, 105),
        toolbarHeight: 70,
        title: const Text("Koperasi Undiksha",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Profile Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color.fromARGB(255, 0, 21, 105)),
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              '../assets/profile.jpg',
                              width: 90,
                              height: 90,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nasabah',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NasabahProvider().nama,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Total Saldo Anda',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IntrinsicWidth(
                                      child: Row(
                                        children: [
                                          Consumer<NasabahProvider>(
                                            builder: (context, nasabahProvider, _) {
                                              final formatter = NumberFormat.currency(
                                                locale: 'id_ID',
                                                symbol: 'Rp ',
                                              );
                                              return Text(
                                                _isBalanceVisible
                                                    ? formatter.format(nasabahProvider.saldo)
                                                    : "******",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(
                                              _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isBalanceVisible = !_isBalanceVisible;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Menu Grid
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color.fromARGB(255, 0, 21, 105)), 
                  ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildMenuItem(Icons.account_balance_wallet, 'Cek Saldo', const Color.fromARGB(255, 0, 21, 105), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CekSaldoScreen()),
                          );
                          }),
                          _buildMenuItem(Icons.swap_horiz, 'Transfer', const Color.fromARGB(255, 0, 21, 105), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TransferScreen()),
                            );
                          }),
                          _buildMenuItem(Icons.savings, 'Deposito', const Color.fromARGB(255, 0, 21, 105), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DepositoScreen()),
                            );
                          }),
                          _buildMenuItem(Icons.payment, 'Pembayaran', const Color.fromARGB(255, 0, 21, 105), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PembayaranScreen()),
                            );
                          }),
                          _buildMenuItem(Icons.request_quote, 'Pinjaman', const Color.fromARGB(255, 0, 21, 105), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PinjamanScreen()),
                            );
                          }),
                          _buildMenuItem(Icons.receipt_long, 'Mutasi', const Color.fromARGB(255, 0, 21, 105), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MutasiScreen()),                              
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Bantuan Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color.fromARGB(255, 0, 21, 105)), 
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Butuh Bantuan?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '0878-1234-1024',
                        style: TextStyle(
                          color: Color(0xFF1A237E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A237E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 209, 215, 255),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(Icons.settings, 'Setting', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                }),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: const Color.fromARGB(255, 0, 21, 105),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                _buildBottomNavItem(Icons.person, 'Profile',  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),                              
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Tambahkan aksi saat diklik
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), // Background untuk ikon dan teks
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 50,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildBottomNavItem(IconData icon, String label, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 0, 21, 105), size: 30,),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
