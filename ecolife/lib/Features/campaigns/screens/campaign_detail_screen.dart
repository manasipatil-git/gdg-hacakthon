import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/campaign.dart';
import '../../../core/services/participation_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/constants/colors.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign campaign;

  const CampaignDetailScreen({
    Key? key,
    required this.campaign,
  }) : super(key: key);

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _hasJoined = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkJoinStatus();
  }

  Future<void> _checkJoinStatus() async {
    final userId = FirebaseService.getCurrentUserId();
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    final joined = await ParticipationService.hasUserParticipated(
      userId: userId,
      campaignId: widget.campaign.id,
    );

    setState(() {
      _hasJoined = joined;
      _loading = false;
    });
  }

  Future<void> _joinCampaign() async {
    final userId = FirebaseService.getCurrentUserId();
    if (userId == null) {
      _showSnack('Please login first', true);
      return;
    }

    setState(() => _loading = true);

    final result = await ParticipationService.joinCampaign(
      userId: userId,
      campaignId: widget.campaign.id,
      campaignTitle: widget.campaign.title,
    );

    setState(() => _loading = false);

    if (result != null) {
      setState(() => _hasJoined = true);
      _showSnack('Successfully joined campaign! 🎉', false);
    } else {
      _showSnack('Failed to join campaign', true);
    }
  }

  void _showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDonateDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DonateScreen(campaign: widget.campaign),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                // App Bar with Image
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          campaign.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.campaign,
                                size: 80,
                                color: Colors.grey.shade500,
                              ),
                            );
                          },
                        ),
                        // Gradient overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Organization Name
                              Row(
                                children: [
                                  Icon(
                                    Icons.business,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    campaign.organizationName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Campaign Title
                              Text(
                                campaign.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Location and Date
                              if (campaign.location != null)
                                _buildInfoRow(
                                  Icons.location_on,
                                  campaign.location!,
                                ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.calendar_today,
                                DateFormat('MMM dd, yyyy')
                                    .format(campaign.endDate),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Progress Stats Container
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Progress Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${campaign.goal.current.toInt()} / ${campaign.goal.target.toInt()} ${campaign.goal.unit}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${campaign.goal.progressPercentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value:
                                      campaign.goal.progressPercentage / 100,
                                  minHeight: 12,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Stats Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStat(
                                    Icons.people,
                                    campaign.progress.participantCount
                                        .toString(),
                                    'Participants',
                                  ),
                                  _buildStat(
                                    Icons.currency_rupee,
                                    '₹${campaign.progress.totalDonations.toInt()}K',
                                    'Raised',
                                  ),
                                  _buildStat(
                                    Icons.volunteer_activism,
                                    campaign.progress.volunteerCount
                                        .toString(),
                                    'Volunteers',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // About Section
                              const Text(
                                'About this campaign',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                campaign.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                ),
                              ),

                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Join/Joined Button
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _hasJoined ? null : _joinCampaign,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasJoined
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                      foregroundColor:
                          _hasJoined ? Colors.grey.shade600 : Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasJoined ? Icons.check_circle : Icons.group_add,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasJoined ? 'Joined' : 'Join Campaign',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Donate Button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _showDonateDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.favorite, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Donate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// Donate Screen
class _DonateScreen extends StatefulWidget {
  final Campaign campaign;

  const _DonateScreen({required this.campaign});

  @override
  State<_DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<_DonateScreen> {
  int? _selectedAmount;
  final _customController = TextEditingController();
  final _messageController = TextEditingController();
  bool _anonymous = false;

  final List<int> _amounts = [100, 500, 1000, 2000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Make a Donation',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.campaign.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.campaign.organizationName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Select Amount
            const Text(
              'Select Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Amount Chips
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _amounts.map((amount) {
                final isSelected = _selectedAmount == amount;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = amount;
                      _customController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '₹$amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Custom Amount
            TextField(
              controller: _customController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Custom Amount',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                prefixText: '₹ ',
                prefixStyle: const TextStyle(color: Colors.black87),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedAmount = null;
                  });
                }
              },
            ),

            const SizedBox(height: 32),

            // Message Field
            const Text(
              'Add a Message (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Leave a message of support...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Anonymous Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Donate anonymously',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Your name won\'t be displayed publicly',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _anonymous,
                    onChanged: (value) {
                      setState(() {
                        _anonymous = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Donate Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // Handle donation
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Thank you for your donation! 💚'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Donate Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}