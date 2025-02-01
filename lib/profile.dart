import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Background
            Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.green.shade900,
                    Colors.green.shade800,
                    Colors.green.shade700,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://api.placeholder.com/100/100',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Verified Lender',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildStatCard(
                    'Active Loans',
                    '\$45,500',
                    Icons.payments,
                    Colors.green.shade800,
                  ),
                  SizedBox(width: 16),
                  _buildStatCard(
                    'Interest Earned',
                    '\$3,240',
                    Icons.trending_up,
                    Colors.green.shade900,
                  ),
                ],
              ),
            ),

            // Loan Portfolio Overview
            _buildSection(
              'Loan Portfolio',
              [
                _buildSettingsTile(
                  'Total Amount Lent',
                  Icons.account_balance_wallet,
                  trailing: Text(
                    '\$78,500',
                    style: TextStyle(
                      color: Colors.green.shade400,
                    ),
                  ),
                ),
                _buildSettingsTile(
                  'Active Borrowers',
                  Icons.people_outline,
                  trailing: Text(
                    '12',
                    style: TextStyle(
                      color: Colors.green.shade400,
                    ),
                  ),
                ),
                _buildSettingsTile(
                  'Recovery Rate',
                  Icons.assignment_turned_in,
                  trailing: Text(
                    '98.5%',
                    style: TextStyle(
                      color: Colors.green.shade400,
                    ),
                  ),
                ),
              ],
            ),

            // Quick Actions
            _buildSection(
              'Quick Actions',
              [
                _buildSettingsTile(
                  'Add New Loan',
                  Icons.add_circle_outline,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Record Payment',
                  Icons.payment,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Calculate Interest',
                  Icons.calculate,
                  onTap: () {},
                ),
              ],
            ),

            // Recent Activities
            _buildSection(
              'Recent Activities',
              [
                _buildActivityTile(
                  'Payment Received',
                  'From: Michael Brown - \$1,500',
                  '2h ago',
                ),
                _buildActivityTile(
                  'New Loan Added',
                  'To: Sarah Wilson - \$5,000',
                  '1d ago',
                ),
                _buildActivityTile(
                  'Interest Collected',
                  'From: David Clark - \$350',
                  '2d ago',
                ),
              ],
            ),

            // Documents & Templates
            _buildSection(
              'Documents & Templates',
              [
                _buildSettingsTile(
                  'Loan Agreements',
                  Icons.description_outlined,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Payment Receipts',
                  Icons.receipt_long,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Statement Templates',
                  Icons.file_copy_outlined,
                  onTap: () {},
                ),
              ],
            ),

            // Settings
            _buildSection(
              'Settings',
              [
                _buildSettingsTile(
                  'Interest Rate Templates',
                  Icons.percent,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Payment Reminders',
                  Icons.notifications_outlined,
                  onTap: () {},
                ),
                _buildSettingsTile(
                  'Default Terms',
                  Icons.rule_outlined,
                  onTap: () {},
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: children,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.green.shade400,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
      onTap: onTap,
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade900,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.green.shade400,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
