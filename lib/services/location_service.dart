// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  // Cek permission lokasi
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Dapatkan posisi saat ini
  Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await checkPermission();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Konversi koordinat ke alamat menggunakan OpenStreetMap Nominatim API
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1'
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'UtsNandaApp/1.0', // Wajib untuk Nominatim
          'Accept-Language': 'id', // Bahasa Indonesia
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['address'] != null) {
          final address = data['address'];

          // Buat alamat yang lebih readable
          List<String> addressParts = [];

          if (address['road'] != null) addressParts.add(address['road']);
          if (address['suburb'] != null) addressParts.add(address['suburb']);
          if (address['city'] != null) {
            addressParts.add(address['city']);
          } else if (address['town'] != null) {
            addressParts.add(address['town']);
          } else if (address['village'] != null) {
            addressParts.add(address['village']);
          }
          if (address['state'] != null) addressParts.add(address['state']);
          if (address['country'] != null) addressParts.add(address['country']);

          return addressParts.join(', ');
        }

        // Fallback ke display_name jika address details tidak ada
        return data['display_name'] ?? 'Alamat tidak ditemukan';
      } else {
        print('Error response: ${response.statusCode}');
        return 'Error mendapatkan alamat (${response.statusCode})';
      }
    } catch (e) {
      print('Error getting address: $e');
      return 'Error mendapatkan alamat';
    }
  }

  // Buka pengaturan lokasi
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Buka pengaturan app
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}