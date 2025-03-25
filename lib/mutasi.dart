import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MutasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mutasiProvider = Provider.of<MutasiProvider>(context);
    final mutasi = mutasiProvider.mutasi.reversed.toList(); // Urutkan terbaru ke terlama

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 21, 105),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 21, 105),
        centerTitle: true,
        title: const Text(
          'Mutasi Transaksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: mutasi.isEmpty
              ? const Center(child: Text('Belum ada transaksi.'))
              : ListView.builder(
                  itemCount: mutasi.length,
                  itemBuilder: (context, index) {
                    final transaksi = mutasi[index];
                    final isKredit = transaksi.isKredit;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: isKredit ? Colors.green : Colors.red,
                          child: Icon(
                            isKredit ? Icons.arrow_downward : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          transaksi.deskripsi,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(transaksi.tanggal),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '${isKredit ? '+' : '-'}Rp ${transaksi.jumlah.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isKredit ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
