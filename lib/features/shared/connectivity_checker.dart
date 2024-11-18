import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityChecker extends StatefulWidget {
  final Widget child;
  final Widget? offlineWidget; // Widget untuk ditampilkan ketika offline
  final Widget? errorWidget; // Widget untuk error lainnya
  final Function(bool) internet;

  const ConnectivityChecker({
    Key? key,
    required this.child,
    this.offlineWidget = const Center(child: Text('No internet connection.', style: TextStyle(color: Colors.red))),
    this.errorWidget = const Center(child: Text('An error occurred.', style: TextStyle(color: Colors.red))),
    required this.internet,
  }) : super(key: key);

  @override
  _ConnectivityCheckerState createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  bool _isOffline = false;
  bool _isChecking = false; // Untuk menandai jika sedang memeriksa koneksi

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    setState(() {
      _isChecking = true; // Menandakan bahwa kita sedang memeriksa koneksi
    });

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      setState(() {
        _isOffline = connectivityResult == ConnectivityResult.none;
        widget.internet(_isOffline);
      });
    } catch (e) {
      setState(() {
        _isOffline = true; // Anggap offline jika ada error saat memeriksa koneksi
        widget.internet(_isOffline);
      });
    } finally {
      setState(() {
        _isChecking = false; // Memperbarui status setelah pemeriksaan selesai
        widget.internet(_isOffline);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Center(child: CircularProgressIndicator()); // Menampilkan indikator loading saat pemeriksaan koneksi
    }

    if (_isOffline) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.offlineWidget ??
              const Center(child: Text('No internet connection.', style: TextStyle(color: Colors.red))),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkConnectivity, // Memeriksa koneksi lagi ketika tombol ditekan
            child: const Text('Refresh'),
          ),
        ],
      );
    }

    return widget.child; // Jika online, tampilkan widget utama
  }
}
