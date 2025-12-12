// lib/widgets/gps_location_card.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';

class GpsLocationCard extends StatefulWidget {
  final VoidCallback? onAddressUpdated;

  const GpsLocationCard({Key? key, this.onAddressUpdated}) : super(key: key);

  @override
  _GpsLocationCardState createState() => _GpsLocationCardState();
}

class _GpsLocationCardState extends State<GpsLocationCard> {
  final _locationService = LocationService();
  final _authService = AuthService();

  bool _isLoadingLocation = false;
  String? _currentLatitude;
  String? _currentLongitude;
  String? _currentAddress;
  String? _accuracy;
  String? _lastUpdated;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position? position = await _locationService.getCurrentPosition();

      if (position != null) {
        // Dapatkan alamat dari OpenStreetMap Nominatim API
        String address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        setState(() {
          _currentLatitude = position.latitude.toStringAsFixed(6);
          _currentLongitude = position.longitude.toStringAsFixed(6);
          _currentAddress = address;
          _accuracy = '${position.accuracy.toStringAsFixed(2)} m';
          _lastUpdated = _formatDateTime(DateTime.now());
          _isLoadingLocation = false;
        });

        // Tampilkan dialog konfirmasi untuk update address
        _showUpdateAddressDialog(address);
      } else {
        setState(() {
          _isLoadingLocation = false;
        });

        _showLocationPermissionDialog();
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _showUpdateAddressDialog(String address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Expanded(child: Text('Lokasi Didapatkan')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alamat berdasarkan GPS:'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                address,
                style: TextStyle(fontSize: 13),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Apakah Anda ingin menyimpan alamat ini ke profile?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lokasi didapatkan, tapi tidak disimpan ke profile'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updateAddressToFirebase(address);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3A5F),
            ),
            child: Text('Ya, Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAddressToFirebase(String address) async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        // Tampilkan loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Menyimpan alamat...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // Update address di Firebase
        bool success = await _authService.updateUserData(user.uid, {
          'address': address,
        });

        if (success) {
          // Callback untuk reload user data di parent
          if (widget.onAddressUpdated != null) {
            widget.onAddressUpdated!();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Alamat berhasil disimpan ke profile!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          throw Exception('Gagal menyimpan ke database');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Gagal menyimpan alamat: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('Izin Lokasi Diperlukan')),
          ],
        ),
        content: Text(
          'Aplikasi membutuhkan izin akses lokasi untuk mendapatkan koordinat GPS Anda. Silakan aktifkan GPS dan berikan izin lokasi di pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _locationService.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3A5F),
            ),
            child: Text('Buka Pengaturan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildGPSInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF2E5A8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E3A5F).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Lokasi GPS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_isLoadingLocation)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),

          if (_currentLatitude != null && _currentLongitude != null) ...[
            _buildGPSInfoRow('Latitude', _currentLatitude!),
            SizedBox(height: 8),
            _buildGPSInfoRow('Longitude', _currentLongitude!),
            SizedBox(height: 8),
            _buildGPSInfoRow('Accuracy', _accuracy ?? '-'),
            SizedBox(height: 8),
            _buildGPSInfoRow('Updated', _lastUpdated ?? '-'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pin_drop, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentAddress ?? 'Mendapatkan alamat...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ] else ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white70),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Belum ada data lokasi. Tekan tombol di bawah untuk mendapatkan lokasi.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              icon: Icon(Icons.my_location),
              label: Text(
                  _isLoadingLocation
                      ? 'Mendapatkan Lokasi...'
                      : 'Dapatkan Lokasi Saat Ini'
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1E3A5F),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}