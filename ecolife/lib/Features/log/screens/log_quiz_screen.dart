import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/log_controller.dart';
import '../widgets/log_progress_bar.dart';
import '../widgets/log_option_card.dart';
import '../widgets/log_summary_card.dart';
import 'log_questions.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/firestore_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final LogController _controller = LogController();
  
  int currentQuestionIndex = 0;
  List<LogQuestion> activeQuestions = [];
  String? selected;
  bool showSummary = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _buildActiveQuestions();
    
    // Check if "Same as Yesterday" was triggered from dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['useYesterday'] == true) {
        _useYesterday();
      }
    });
  }

  // Build list of questions to show based on answers
  void _buildActiveQuestions() {
    activeQuestions.clear();
    
    for (var question in allQuestions) {
      if (question.shouldShow == null || question.shouldShow!(_controller.answers)) {
        activeQuestions.add(question);
      }
    }
    
    setState(() {});
  }

  // Handle answer selection
  void _handleAnswer(dynamic value) {
    final question = activeQuestions[currentQuestionIndex];
    
    _controller.addAnswer(question.id, value);
    setState(() {
      selected = value.toString();
    });

    // Delay before moving to next question
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      // Rebuild questions list (some may now show/hide)
      _buildActiveQuestions();
      
      // Move to next or finish
      if (currentQuestionIndex + 1 < activeQuestions.length) {
        setState(() {
          currentQuestionIndex++;
          selected = null;
        });
      } else {
        setState(() {
          showSummary = true;
        });
      }
    });
  }

  // Same as Yesterday quick log
  void _useYesterday() async {
    setState(() => isSubmitting = true);
    
    try {
      await _controller.logSameAsYesterday();
      
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Submit the log
  Future<void> _submit() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _controller.submit();
      
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: showSummary ? _buildSummaryView() : _buildQuestionView(),
        ),
      ),
    );
  }

  Widget _buildQuestionView() {
    if (activeQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = activeQuestions[currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Score Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eco Score',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '+${_controller.ecoScore}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'CO₂ Today',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${_controller.totalEmissions.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _controller.totalEmissions < 1.0 
                          ? Colors.green 
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Same as Yesterday button
        if (currentQuestionIndex == 0)
          GestureDetector(
            onTap: _useYesterday,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.9),
                    AppColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Same as yesterday',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Progress bar
        LogProgressBar(
          step: currentQuestionIndex + 1,
          total: activeQuestions.length,
        ),

        const SizedBox(height: 32),

        // Question with icon
        Row(
          children: [
            if (question.icon != null) ...[
              Text(
                question.icon!,
                style: const TextStyle(fontSize: 32),
              ),
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

        const SizedBox(height: 24),

        // Options
        Expanded(
          child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final option = question.options[index];
              return LogOptionTile(
                text: option.text,
                emoji: option.emoji,
                selected: selected == option.value.toString(),
                onTap: () => _handleAnswer(option.value),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Today\'s Impact 🌱',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Emissions display
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                '${_controller.totalEmissions.toStringAsFixed(2)} kg CO₂',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: _controller.totalEmissions < 1.0 
                      ? Colors.green 
                      : _controller.totalEmissions < 2.0
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.totalEmissions < 1.0
                    ? '🎉 Excellent! Low-impact day'
                    : _controller.totalEmissions < 2.0
                        ? '👍 Good! Room for improvement'
                        : '⚠️ High impact. Try to reduce',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        
        LogSummaryCard(score: _controller.ecoScore),
        
        const SizedBox(height: 40),
        
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
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
                : const Text(
                    'Finish',
                    style: TextStyle(fontSize: 18),
                  ),
          ),
        ),
      ],
    );
  }
}