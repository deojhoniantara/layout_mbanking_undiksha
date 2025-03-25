import 'package:flutter/material.dart';

class Transaksi {
  final DateTime tanggal;
  final String deskripsi;
  final double jumlah;
  final bool isKredit;
  final String? rekeningTujuan;

  Transaksi({
    required this.tanggal,
    required this.deskripsi,
    required this.jumlah,
    required this.isKredit,
    this.rekeningTujuan,
  });
}

class MutasiProvider with ChangeNotifier {
  List<Transaksi> _mutasi = [];

  List<Transaksi> get mutasi => _mutasi;

  void tambahTransaksi(Transaksi transaksi) {
    _mutasi.add(transaksi);
    notifyListeners();
  }

  void resetMutasi() {
    _mutasi.clear();
    notifyListeners();
  }
}
