import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/rewards_service.dart';
import '../models/reward_model.dart';
import '../../../core/constants/colors.dart';

class HistoryTab extends StatelessWidget {
  final String uid;

  const HistoryTab({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RedemptionHistory>>(
      stream: RewardsService().getRedemptionHistory(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No redemptions yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your redeemed rewards will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        final history = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return _HistoryCard(item: item);
          },
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final RedemptionHistory item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isUsed ? Colors.grey.shade200 : AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: item.isUsed 
                  ? Colors.grey.shade100 
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      item.itemEmoji,
                      style: TextStyle(
                        fontSize: 32,
                        color: item.isUsed ? Colors.grey : null,
                      ),
                    ),
                  ),
                  if (item.isUsed)
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: item.isUsed ? Colors.grey.shade600 : Colors.black87,
                    decoration: item.isUsed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(item.redeemedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // Points badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: item.isUsed 
                      ? Colors.grey.shade200 
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      size: 14,
                      color: item.isUsed ? Colors.grey.shade600 : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.pointsCost}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: item.isUsed ? Colors.grey.shade600 : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (item.isUsed)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Used',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}