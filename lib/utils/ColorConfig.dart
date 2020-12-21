import 'package:flutter/material.dart';

class ColorConfig {
  static MaterialColor getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.blue;
        break;
      case 'Dalam Tindakan':
        return Colors.cyan;
        break;
      case 'Baharu':
        return Colors.green;
        break;
      case 'Selesai':
        return Colors.grey;
        break;
      case 'Ditolak':
        return Colors.red;
        break;
      case 'Dipindah':
        return Colors.orange;
        break;
      case 'Bertindih':
        return Colors.purple;
        break;
      default:
        return Colors.blue;
        break;
    }
  }
}
