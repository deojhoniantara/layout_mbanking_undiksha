import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/nasabah_provider.dart';

class FormPembayaranScreen extends StatefulWidget {
  final String kategori;

  const FormPembayaranScreen({super.key, required this.kategori});

  @override
  State<FormPembayaranScreen> createState() => _FormPembayaranScreenState();
}

class _FormPembayaranScreenState extends State<FormPembayaranScreen> {
  final TextEditingController _vaController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

void _prosesPembayaran(BuildContext context) {
  final va = _vaController.text.trim();
  final jumlah = int.tryParse(_nominalController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;

  if (va.isEmpty || jumlah <= 0) {
    _showDialog('VA dan jumlah pembayaran harus valid');
    return;
  }

  final saldoProvider = context.read<NasabahProvider>();
  final currentSaldo = saldoProvider.saldo;

  if (jumlah > currentSaldo) {
    _showDialog('Saldo tidak mencukupi untuk melakukan pembayaran.');
    return;
  }

  final formattedJumlah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(jumlah);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Konfirmasi Pembayaran'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lanjutkan pembayaran untuk kategori: ${widget.kategori}?'),
          const SizedBox(height: 8),
          Text('VA: $va', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Nominal: $formattedJumlah', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () {
            // Mengurangi saldo menggunakan fungsi kurangiSaldo
            saldoProvider.kurangiSaldo(jumlah.toDouble(), va, context.read<MutasiProvider>());
            
            Navigator.pop(context);
            _showDialog('Pembayaran ${widget.kategori} ke VA $va berhasil!');
            _vaController.clear();
            _nominalController.clear();

            // Menambahkan transaksi mutasi
            final txProvider = context.read<MutasiProvider>();
            txProvider.tambahTransaksi(Transaksi(
              tanggal: DateTime.now(),
              deskripsi: '${widget.kategori} ke VA $va',
              jumlah: jumlah.toDouble(),
              isKredit: false, // Saldo berkurang
              rekeningTujuan: va,
            ));
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Bayar Sekarang'),
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 21, 105),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 21, 105),
        toolbarHeight: 70,
        title: Text(
          "Pembayaran ${widget.kategori}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan Nomor Virtual Account",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 21, 105),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _vaController,
                decoration: InputDecoration(
                  labelText: 'Nomor Virtual Account',
                  hintText: 'Contoh: 1234567890',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nominalController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Pembayaran',
                  hintText: 'Contoh: 100000',
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
                  onPressed: () => _prosesPembayaran(context),
                  child: const Text(
                    'BAYAR',
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
    );
  }
}
