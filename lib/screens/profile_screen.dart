import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;

  const ProfileScreen({required this.userId, Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    final db = await DBHelper().database;

    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    return results.isNotEmpty ? results.first : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User data not found.'));
          }

          final userData = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar and Name
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    userData['username']?.substring(0, 1).toUpperCase() ?? "?",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userData['full_name'] ?? "Full Name Not Provided",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['email'] ?? "Email Not Provided",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Details
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileRow(
                          icon: Icons.person,
                          label: "Username",
                          value: userData['username'] ?? "-",
                        ),
                        const Divider(),
                        _buildProfileRow(
                          icon: Icons.phone,
                          label: "Phone Number",
                          value: userData['phone_number'] ?? "Not Provided",
                        ),
                        const Divider(),
                        _buildProfileRow(
                          icon: Icons.calendar_today,
                          label: "Account Created",
                          value: userData['created_at'] ?? "-",
                        ),
                        const Divider(),
                        _buildProfileRow(
                          icon: Icons.update,
                          label: "Last Updated",
                          value: userData['updated_at'] ?? "-",
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout Button
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}