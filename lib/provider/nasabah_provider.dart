import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/mutasi_provider.dart';

class NasabahProvider with ChangeNotifier {
  String _nama = 'I Kadek Deo Jhoniantara';
  double _saldo = 4800000;
  String _noRekening = '2315091083';
  String _noKartu = '2315-0910-8323-1509';

  String get nama => _nama;
  double get saldo => _saldo;
  String get noRekening => _noRekening;
  String get noKartu => _noKartu;

  void setNasabah(String nama, double saldo, String noRekening, String noKartu) {
    _nama = nama;
    _saldo = saldo;
    _noRekening = noRekening;
    _noKartu = noKartu;
    notifyListeners();
  }

  void tambahSaldo(double amount, MutasiProvider mutasiProvider) {
    if (_saldo + amount >= 0) {
      _saldo += amount;

      notifyListeners();
    } else {
      throw Exception("Saldo tidak mencukupi untuk melakukan transaksi.");
    }
  }

  void kurangiSaldo(double amount, String rekeningTujuan, MutasiProvider mutasiProvider) {
    if (_saldo >= amount) {
      _saldo -= amount;

      notifyListeners();
    } else {
      throw Exception("Saldo tidak mencukupi untuk melakukan transaksi.");
    }
  }
}
