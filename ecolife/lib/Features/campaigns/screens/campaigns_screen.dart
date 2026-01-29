import 'package:flutter/material.dart';
import '../../../core/models/campaign.dart';
import '../../../core/services/campaign_service.dart';
import 'create_campaign_screen.dart';
import 'campaign_detail_screen.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateCampaignScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Campaign>>(
        stream: CampaignService.getActiveCampaignsStream(),
        builder: (context, snapshot) {
          // 🐛 DEBUG LOGGING
          print('🔍 Connection State: ${snapshot.connectionState}');
          
          if (snapshot.hasError) {
            print('❌ Error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('⏳ Loading campaigns...');
            return const Center(child: CircularProgressIndicator());
          }

          print('📊 Campaign Count: ${snapshot.data?.length ?? 0}');

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('⚠️ No campaigns found');
            return const Center(
              child: Text('No campaigns available'),
            );
          }

          final campaigns = snapshot.data!;
          
          // Print each campaign for debugging
          for (var i = 0; i < campaigns.length; i++) {
            print('Campaign $i: ${campaigns[i].title}');
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              return _CampaignCard(campaign: campaign);
            },
          );
        },
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;

  const _CampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CampaignDetailScreen(campaign: campaign),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                campaign.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.campaign,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            
            // Campaign Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor(campaign.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      campaign.type.displayName,
                      style: TextStyle(
                        color: _getTypeColor(campaign.type),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Campaign Title
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Organization Name
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          campaign.organizationName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  // Location (if available)
                  if (campaign.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            campaign.location!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            campaign.goal.type.displayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${campaign.goal.progressPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: campaign.goal.progressPercentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getTypeColor(campaign.type),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${campaign.goal.current.toInt()} / ${campaign.goal.target.toInt()} ${campaign.goal.unit}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Participants Count
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${campaign.progress.participantCount} participants',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(CampaignType type) {
    switch (type) {
      case CampaignType.treePlantation:
        return Colors.green;
      case CampaignType.cleanliness:
        return Colors.blue;
      case CampaignType.donation:
        return Colors.orange;
    }
  }
}