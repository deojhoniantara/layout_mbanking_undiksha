import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/nasabah_provider.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  void _transferSaldo(BuildContext context) {
    final nasabahProvider = context.read<NasabahProvider>();
    final mutasiProvider = context.read<MutasiProvider>();
    final saldo = nasabahProvider.saldo;
    final jumlah = double.tryParse(_jumlahController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    final rekening = _rekeningController.text.trim();

    if (jumlah <= 0 || rekening.isEmpty) {
      _showDialog('Nomor rekening atau jumlah transfer tidak valid');
      return;
    }

    if (jumlah > saldo) {
      _showDialog('Saldo Anda tidak cukup');
    } else {
      final formattedJumlah = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 2,
      ).format(jumlah);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Konfirmasi Transfer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Apakah Anda yakin ingin mentransfer'),
              const SizedBox(height: 8),
              Text(
                formattedJumlah,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('ke rekening: $rekening'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  nasabahProvider.kurangiSaldo(jumlah, rekening, mutasiProvider);
                  mutasiProvider.tambahTransaksi(Transaksi(
                    tanggal: DateTime.now(),
                    jumlah: jumlah,
                    deskripsi: 'Transfer ke rekening $rekening',
                    isKredit: false,
                  ));

                  Navigator.pop(context);
                  _showDialog('Transfer berhasil ke rekening $rekening sejumlah $formattedJumlah');
                  _rekeningController.clear();
                  _jumlahController.clear();
                } catch (e) {
                  Navigator.pop(context);
                  _showDialog(e.toString());
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Ya, Transfer'),
            ),
          ],
        ),
      );
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Informasi'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 21, 105),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 21, 105),
        toolbarHeight: 70,
        title: const Text("Transfer",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Consumer<NasabahProvider>(
              builder: (context, nasabahProvider, _) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Saldo Saat Ini",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 21, 105),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatter.format(nasabahProvider.saldo),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 21, 105),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transfer",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 21, 105),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _rekeningController,
                        decoration: InputDecoration(
                          labelText: 'Nomor Rekening Tujuan',
                          hintText: 'Masukkan nomor rekening tujuan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.credit_card),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _jumlahController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Transfer',
                          hintText: 'Masukkan jumlah yang akan ditransfer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.money),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 0, 21, 105),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _transferSaldo(context),
                          child: const Text(
                            'TRANSFER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
