import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _aboutmeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _fullnameController.text = user.fullname ?? '';
      _aboutmeController.text = user.aboutme ?? '';
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _aboutmeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.updateProfile({
      'fullname': _fullnameController.text.trim(),
      'aboutme': _aboutmeController.text.trim(),
    });

    if (success && mounted) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${authProvider.error}')),
      );
    }
  }

  void _cancelEdit() {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _fullnameController.text = user.fullname ?? '';
      _aboutmeController.text = user.aboutme ?? '';
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          if (_isEditing) ...[
            TextButton(
              onPressed: _cancelEdit,
              child: const Text('Cancel'),
            ),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return TextButton(
                  onPressed: authProvider.isLoading ? null : _saveProfile,
                  child: authProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                );
              },
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.picture != null
                        ? CachedNetworkImageProvider(user.avatarUrl)
                        : null,
                    child: user.picture == null
                        ? Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Username (not editable)
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  if (_isEditing)
                    TextFormField(
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 50) {
                          return 'Full name must be less than 50 characters';
                        }
                        return null;
                      },
                    )
                  else
                    _buildInfoCard(
                      'Full Name',
                      user.fullname?.isNotEmpty == true ? user.fullname! : 'Not set',
                      Icons.person,
                    ),
                  const SizedBox(height: 16),

                  // Email (not editable)
                  _buildInfoCard('Email', user.email, Icons.email),
                  const SizedBox(height: 16),

                  // About Me
                  if (_isEditing)
                    TextFormField(
                      controller: _aboutmeController,
                      decoration: const InputDecoration(
                        labelText: 'About Me',
                        prefixIcon: Icon(Icons.info),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.length > 200) {
                          return 'About me must be less than 200 characters';
                        }
                        return null;
                      },
                    )
                  else
                    _buildInfoCard(
                      'About Me',
                      user.aboutme?.isNotEmpty == true ? user.aboutme! : 'Tell us about yourself',
                      Icons.info,
                    ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard('Posts', user.postcount.toString()),
                      _buildStatCard('Reputation', user.reputation.toString()),
                      _buildStatCard(
                        'Member Since',
                        '${user.joindate.day}/${user.joindate.month}/${user.joindate.year}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // User Groups/Roles
                  if (user.groups.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Roles',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: user.groups.map((group) => Chip(
                                label: Text(group),
                                backgroundColor: _getRoleColor(group),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await authProvider.logout();
                        if (mounted) {
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'administrators':
      case 'admin':
        return Colors.red[100]!;
      case 'moderators':
      case 'moderator':
        return Colors.orange[100]!;
      case 'mvp users':
      case 'mvp':
        return Colors.purple[100]!;
      case 'special users':
      case 'special':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}
