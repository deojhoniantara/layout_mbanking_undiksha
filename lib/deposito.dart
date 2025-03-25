import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/nasabah_provider.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';

class DepositoScreen extends StatefulWidget {
  @override
  _DepositoScreenState createState() => _DepositoScreenState();
}

class _DepositoScreenState extends State<DepositoScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _buatDeposito(BuildContext context) {
    final saldoProvider = context.read<NasabahProvider>();
    final saldo = saldoProvider.saldo;

    final jumlah = double.tryParse(_amountController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    final bulan = int.tryParse(_durationController.text) ?? 0;

    if (jumlah <= 0 || bulan <= 0) {
      _showDialog('Jumlah deposito dan lama bulan harus valid.');
      return;
    }

    if (jumlah > saldo) {
      _showDialog('Saldo tidak mencukupi untuk membuat deposito.');
      return;
    }

    final formattedJumlah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    ).format(jumlah);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Deposito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Anda akan membuat deposito sebesar:'),
            const SizedBox(height: 8),
            Text(
              formattedJumlah,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Selama $bulan bulan'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final mutasiProvider = context.read<MutasiProvider>();
              saldoProvider.tambahSaldo(jumlah, mutasiProvider);
              mutasiProvider.tambahTransaksi(Transaksi(
                tanggal: DateTime.now(),
                deskripsi: 'Deposito selama $bulan bulan',
                jumlah: jumlah,
                isKredit: true,
              ),
              );
              Navigator.pop(context);
              _showDialog('Deposito berhasil dibuat sebesar $formattedJumlah selama $bulan bulan.');
              _amountController.clear();
              _durationController.clear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Ya, Buat'),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Informasi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
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
        title: const Text(
          "Deposito",
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
                        "Buat Deposito",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 21, 105),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Deposito',
                          hintText: 'Masukkan jumlah yang ingin ditabung',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.money),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _durationController,
                        decoration: InputDecoration(
                          labelText: 'Lama Deposito (bulan)',
                          hintText: 'Contoh: 6',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
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
                          onPressed: () => _buatDeposito(context),
                          child: const Text(
                            'BUAT DEPOSITO',
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
