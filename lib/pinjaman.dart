import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/nasabah_provider.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PinjamanScreen extends StatefulWidget {
  @override
  State<PinjamanScreen> createState() => _PinjamanScreenState();
}

class _PinjamanScreenState extends State<PinjamanScreen> {
  final TextEditingController amountController = TextEditingController();
  int? selectedTenor;

  final double bungaPerTahun = 0.10;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double jumlahPinjaman = double.tryParse(amountController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    double totalBunga = jumlahPinjaman * bungaPerTahun;
    double totalKembali = jumlahPinjaman + totalBunga;
    double angsuranPerBulan = selectedTenor != null && selectedTenor! > 0
        ? totalKembali / selectedTenor!
        : 0;

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
          "Pinjaman",
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
                        "Bunga per Tahun",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 21, 105),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '10%',
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
                        "Ajukan Pinjaman",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 21, 105),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: amountController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Pinjaman',
                          hintText: 'Masukkan jumlah pinjaman',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.money),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Pilih Tenor',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
                        ),
                        value: selectedTenor,
                        items: const [
                          DropdownMenuItem(value: 3, child: Text('3 Bulan')),
                          DropdownMenuItem(value: 6, child: Text('6 Bulan')),
                          DropdownMenuItem(value: 12, child: Text('12 Bulan')),
                        ],
                        onChanged: (value) => setState(() => selectedTenor = value),
                        dropdownColor: Colors.white,
                      ),
                      const SizedBox(height: 30),
                      _buildLoanCalculation(
                        angsuran: angsuranPerBulan,
                        total: totalKembali,
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
                          onPressed: () {
                            if (jumlahPinjaman <= 0 || selectedTenor == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Masukkan jumlah pinjaman dan tenor yang valid")),
                              );
                              return;
                            }

                            final mutasiProvider = context.read<MutasiProvider>();
                            Provider.of<NasabahProvider>(context, listen: false).tambahSaldo(jumlahPinjaman, mutasiProvider);
                            mutasiProvider.tambahTransaksi(Transaksi(
                              tanggal: DateTime.now(), 
                              deskripsi: 'Pinjaman sebesar ${formatter.format(jumlahPinjaman)}',
                              jumlah: jumlahPinjaman,
                              isKredit: true, 
                              rekeningTujuan: null,
                            ));
                            _showConfirmationDialog(jumlahPinjaman);
                          },
                          child: const Text(
                            'AJUKAN PINJAMAN',
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

  void _showConfirmationDialog(double jumlahPinjaman) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pengajuan Pinjaman Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pinjaman Anda berhasil dicairkan!'),
            const SizedBox(height: 8),
            Text(
              'Pinjaman sebesar ${formatter.format(jumlahPinjaman)} telah dicairkan.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset the inputs after successful loan request
              amountController.clear();
              setState(() => selectedTenor = null);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCalculation({required double angsuran, required double total}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildLoanDetailRow('Angsuran per Bulan', 'Rp ${angsuran.toStringAsFixed(0)}'),
          const Divider(),
          _buildLoanDetailRow('Total Pengembalian', 'Rp ${total.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
