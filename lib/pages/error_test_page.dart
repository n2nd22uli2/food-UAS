// lib/pages/error_test_page.dart
import 'package:flutter/material.dart';
import '../helpers/debug_error_helper.dart';
import '../navigasi/home_page.dart';

/// Page khusus untuk testing error handling
/// Akses via: Navigator.push(context, MaterialPageRoute(builder: (_) => ErrorTestPage()))
class ErrorTestPage extends StatefulWidget {
  @override
  _ErrorTestPageState createState() => _ErrorTestPageState();
}

class _ErrorTestPageState extends State<ErrorTestPage> {
  ErrorSimulationType _selectedError = ErrorSimulationType.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🐛 Error Testing'),
        backgroundColor: Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Header
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'DEBUG MODE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Testing error handling untuk screenshot.\nPilih error type lalu buka HomePage.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Current Status
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DebugErrorHelper.enableErrorSimulation
                  ? Colors.red[50]
                  : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DebugErrorHelper.enableErrorSimulation
                    ? Colors.red
                    : Colors.green,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  DebugErrorHelper.enableErrorSimulation
                      ? Icons.bug_report
                      : Icons.check_circle,
                  color: DebugErrorHelper.enableErrorSimulation
                      ? Colors.red
                      : Colors.green,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DebugErrorHelper.enableErrorSimulation
                            ? 'Error Simulation: ON'
                            : 'Normal Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (DebugErrorHelper.enableErrorSimulation)
                        Text(
                          DebugErrorHelper.getErrorDescription(_selectedError),
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Error Type Selection
          Text(
            'Select Error Type:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          _buildErrorOption(
            ErrorSimulationType.network,
            '📡 Network Error',
            'Simulate no internet connection',
            Colors.red,
          ),
          _buildErrorOption(
            ErrorSimulationType.timeout,
            '⏱️ Timeout Error',
            'Simulate connection timeout',
            Colors.orange,
          ),
          _buildErrorOption(
            ErrorSimulationType.server,
            '🔧 Server Error',
            'Simulate server is down (500)',
            Colors.purple,
          ),
          _buildErrorOption(
            ErrorSimulationType.notFound,
            '🔍 Not Found',
            'Simulate resource not found (404)',
            Colors.blue,
          ),
          _buildErrorOption(
            ErrorSimulationType.parse,
            '⚠️ Parse Error',
            'Simulate invalid data format',
            Colors.amber,
          ),
          _buildErrorOption(
            ErrorSimulationType.unknown,
            '❌ Unknown Error',
            'Simulate unexpected error',
            Colors.grey,
          ),
          _buildErrorOption(
            ErrorSimulationType.none,
            '✅ Normal Mode',
            'Disable error simulation',
            Colors.green,
          ),

          SizedBox(height: 24),

          // Quick Test Scenarios
          Text(
            'Quick Scenarios:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          _buildScenarioButton(
            'Test All Categories Error',
            'Categories akan error, meals normal',
            Icons.category_outlined,
                () {
              setState(() {
                DebugErrorHelper.setupScenario(TestScenario.immediateNetworkError);
                _selectedError = ErrorSimulationType.network;
              });
              _showSnackBar('Categories error enabled', Colors.red);
            },
          ),

          _buildScenarioButton(
            'Test Random Meals Error',
            'Random meals akan error',
            Icons.restaurant,
                () {
              setState(() {
                DebugErrorHelper.setupScenario(TestScenario.serverError);
                _selectedError = ErrorSimulationType.server;
              });
              _showSnackBar('Meals error enabled', Colors.orange);
            },
          ),

          _buildScenarioButton(
            'Test Timeout (After 2 Success)',
            'Akan timeout setelah 2x success',
            Icons.timer,
                () {
              setState(() {
                DebugErrorHelper.setupScenario(TestScenario.timeoutAfter2Calls);
                _selectedError = ErrorSimulationType.timeout;
              });
              _showSnackBar('Delayed timeout enabled', Colors.purple);
            },
          ),

          SizedBox(height: 24),

          // Action Buttons
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            },
            icon: Icon(Icons.home),
            label: Text('Go to HomePage'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3A5F),
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(16),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                DebugErrorHelper.setupScenario(TestScenario.normal);
                _selectedError = ErrorSimulationType.none;
              });
              _showSnackBar('Error simulation disabled', Colors.green);
            },
            icon: Icon(Icons.refresh),
            label: Text('Reset to Normal'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(16),
              side: BorderSide(color: Colors.green, width: 2),
              foregroundColor: Colors.green,
            ),
          ),

          SizedBox(height: 40),

          // Instructions
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Cara Pakai:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Pilih error type yang mau di-test\n'
                        '2. Klik "Go to HomePage"\n'
                        '3. Lihat error handling UI-nya\n'
                        '4. Screenshot untuk dokumentasi\n'
                        '5. Reset to Normal setelah selesai',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorOption(
      ErrorSimulationType type,
      String title,
      String description,
      Color color,
      ) {
    final isSelected = _selectedError == type;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedError = type;
            DebugErrorHelper.currentError = type;
            DebugErrorHelper.enableErrorSimulation = type != ErrorSimulationType.none;
            DebugErrorHelper.reset();
          });
          _showSnackBar(
            type == ErrorSimulationType.none
                ? 'Normal mode activated'
                : 'Error simulation: $title',
            color,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isSelected ? color : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isSelected ? color : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioButton(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(16),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF1E3A5F)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
}