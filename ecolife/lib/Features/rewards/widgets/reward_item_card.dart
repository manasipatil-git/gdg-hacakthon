import 'package:flutter/material.dart';
import '../data/reward_items.dart';
import '../../../core/constants/colors.dart';

class RewardItemCard extends StatelessWidget {
  final RewardItem item;
  final int userScore;
  final VoidCallback onTap;

  const RewardItemCard({
    super.key,
    required this.item,
    required this.userScore,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool canAfford = userScore >= item.cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canAfford 
              ? AppColors.primary.withOpacity(0.3) 
              : Colors.grey.shade200,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Emoji Icon
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: canAfford
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.2),
                              AppColors.primary.withOpacity(0.1),
                            ],
                          )
                        : null,
                    color: !canAfford ? Colors.grey.shade100 : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: TextStyle(
                        fontSize: 36,
                        color: !canAfford ? Colors.grey : null,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: canAfford ? Colors.black87 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Cost Badge
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: canAfford
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withOpacity(0.8),
                                ],
                              )
                            : null,
                        color: !canAfford ? Colors.grey.shade300 : null,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: canAfford
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars,
                            size: 18,
                            color: canAfford ? Colors.white : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.cost}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: canAfford ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!canAfford)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Need ${item.cost - userScore}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}