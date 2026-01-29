import 'package:flutter/material.dart';
import '../../../core/models/campaign.dart';
import '../../../core/services/participation_service.dart';
import '../../../core/services/firebase_service.dart';

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
      _showSnack('Joined campaign successfully 🎉', false);
    } else {
      _showSnack('Failed to join campaign', true);
    }
  }

  void _showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.title),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.organizationName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    campaign.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Goal Progress',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value:
                        campaign.goal.progressPercentage / 100,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    '${campaign.goal.current.toInt()} / ${campaign.goal.target.toInt()} ${campaign.goal.unit}',
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _hasJoined ? null : _joinCampaign,
                      child: Text(
                        _hasJoined ? 'Already Joined' : 'Join Campaign',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
