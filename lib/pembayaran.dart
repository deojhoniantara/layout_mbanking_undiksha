import 'package:flutter/material.dart';
import 'package:flutter_application_1/form_pembayaran.dart';

class PembayaranScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 21, 105),
        toolbarHeight: 70,
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildPaymentCategory(
                      context: context,
                      icon: Icons.electrical_services,
                      title: "PLN",
                      color: Colors.blue,
                    ),
                    _buildPaymentCategory(
                      context: context,
                      icon: Icons.water_drop,
                      title: "PDAM",
                      color: Colors.blue,
                    ),
                    _buildPaymentCategory(
                      context: context,
                      icon: Icons.trolley,
                      title: "E-Commerce",
                      color: Colors.blue,
                    ),
                    _buildPaymentCategory(
                      context: context,
                      icon: Icons.account_balance_wallet,
                      title: "E-Wallet",
                      color: Colors.blue,
                    ),
                    _buildPaymentCategory(
                      context: context,
                      icon: Icons.phone_android,
                      title: "Pulsa & Data",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCategory({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPembayaranScreen(kategori: title),
            ),
          );
        },
      ),
    );
  }
}
