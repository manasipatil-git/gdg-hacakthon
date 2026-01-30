import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/log_controller.dart';
import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../widgets/log_summary_card.dart';
import 'log_questions.dart';
import '../../../core/constants/colors.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final LogController _controller = LogController();

  int currentIndex = 0;
  List<LogQuestion> activeQuestions = [];
  String? selectedValue;
  bool showSummary = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rebuildQuestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['useYesterday'] == true) {
        _useYesterday();
      }
    });
  }

  void _rebuildQuestions() {
    activeQuestions = allQuestions
        .where(
          (q) => q.shouldShow == null || q.shouldShow!(_controller.answers),
        )
        .toList();
    setState(() {});
  }

  void _onAnswer(dynamic value) {
    final question = activeQuestions[currentIndex];
    _controller.addAnswer(question.id, value);

    setState(() => selectedValue = value.toString());

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      _rebuildQuestions();

      if (currentIndex + 1 < activeQuestions.length) {
        setState(() {
          currentIndex++;
          selectedValue = null;
        });
      } else {
        setState(() => showSummary = true);
      }
    });
  }

  Future<void> _useYesterday() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSubmitting = true);

    try {
      await _controller.logSameAsYesterday(user.uid);
      if (!mounted) return;
      _navigateToDashboard();
    } catch (e, stackTrace) {
      debugPrint('LogQuiz same-as-yesterday error: $e');
      debugPrint('LogQuiz same-as-yesterday stackTrace: $stackTrace');
      if (mounted) _showError(_userFriendlyMessage(e));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _submit() async {
    if (isSubmitting) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('User not logged in');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await _controller.submit(user.uid);
      if (!mounted) return;
      _navigateToDashboard();
    } catch (e, stackTrace) {
      debugPrint('LogQuiz submit error: $e');
      debugPrint('LogQuiz submit stackTrace: $stackTrace');
      if (mounted) _showError(_userFriendlyMessage(e));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (_) => false);
  }

  String _userFriendlyMessage(Object e) {
    if (e is FirebaseException) {
      if (e.code == 'permission-denied') {
        return 'Unable to save. Deploy Firestore rules (see firestore.rules) so daily_logs and users are writable.';
      }
      if (e.code == 'unavailable') {
        return 'Network error. Check your connection and try again.';
      }
    }
    return e.toString();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: showSummary ? _summaryView() : _questionView(),
        ),
      ),
    );
  }

  // ================= UI =================

  /// Derives category accent from question id (UI only; no data change).
  static Color _categoryColorForQuestionId(String questionId) {
    const transportIds = {
      'didTravel',
      'travelMode',
      'distance',
      'fuelType',
      'occupancy',
    };
    const foodIds = {
      'mealType',
      'nonVegMeals',
      'nonVegType',
      'packagedFood',
      'foodSource',
      'foodWastage',
    };
    if (transportIds.contains(questionId))
      return AppColors.logCategoryTransport;
    if (foodIds.contains(questionId)) return AppColors.logCategoryFood;
    return AppColors.logCategoryWater;
  }

  Widget _questionView() {
    final question = activeQuestions[currentIndex];
    final categoryColor = _categoryColorForQuestionId(question.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _liveStats(categoryColor),

        if (currentIndex == 0) _sameAsYesterdayButton(),

        LogProgressBar(
          step: currentIndex + 1,
          total: activeQuestions.length,
          accentColor: categoryColor,
        ),

        const SizedBox(height: 32),

        AnimatedSwitcher(
          duration: MediaQuery.of(context).disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Row(
            key: ValueKey<int>(currentIndex),
            children: [
              if (question.icon != null) ...[
                Text(question.icon!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: ListView(
            children: question.options.map((opt) {
              return LogOptionTile(
                text: opt.text,
                emoji: opt.emoji,
                selected: selectedValue == opt.value.toString(),
                onTap: () => _onAnswer(opt.value),
                categoryColor: categoryColor,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _summaryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Today's Impact 🌱",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 24),

        LogSummaryCard(score: _controller.ecoScore),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Finish', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Widget _liveStats(Color categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: categoryColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '+${_controller.ecoScore} pts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
          Text(
            '${_controller.totalEmissions.toStringAsFixed(1)} kg CO₂',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sameAsYesterdayButton() {
    return GestureDetector(
      onTap: isSubmitting ? null : _useYesterday,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.9), AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Same as yesterday',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
