import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/campaign.dart';
import '../../../core/services/campaign_service.dart';
import '../../../core/services/cloudinary_service.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({Key? key}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _orgController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _targetController = TextEditingController();

  CampaignType _selectedType = CampaignType.treePlantation;
  GoalType _selectedGoalType = GoalType.trees;

  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        isStart ? _startDate = picked : _endDate = picked;
      });
    }
  }

  Future<void> _createCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      _showSnackBar('Please select start and end dates', true);
      return;
    }

    setState(() => _isLoading = true);

    // Always use placeholder image (safe for Windows)
    final imageUrl = await CloudinaryService.pickAndUploadImage();

    final campaign = Campaign(
      id: '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      organizationName: _orgController.text.trim(),
      imageUrl: imageUrl ??
          'https://via.placeholder.com/600/4CAF50/FFFFFF?text=Campaign',
      type: _selectedType,
      location:
          _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      goal: CampaignGoal(
        target: double.parse(_targetController.text),
        current: 0,
        type: _selectedGoalType,
      ),
      progress: CampaignProgress(
        participantCount: 0,
        volunteerCount: 0,
        totalDonations: 0,
      ),
      isFeatured: false,
      isActive: true,
      createdAt: DateTime.now(),
    );

    final result = await CampaignService.createCampaign(campaign);

    setState(() => _isLoading = false);

    if (result != null && mounted) {
      _showSnackBar('Campaign created successfully 🎉', false);
      Navigator.pop(context);
    } else {
      _showSnackBar('Failed to create campaign', true);
    }
  }

  void _showSnackBar(String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Campaign')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Campaign Cover Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Image will be auto-assigned',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Campaign Title *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _orgController,
                decoration: const InputDecoration(labelText: 'Organization Name *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<CampaignType>(
                value: _selectedType,
                items: CampaignType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.displayName),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
                decoration: const InputDecoration(labelText: 'Campaign Type *'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Goal *'),
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter number' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<GoalType>(
                value: _selectedGoalType,
                items: GoalType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text('${e.displayName} (${e.unit})'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGoalType = v!),
                decoration: const InputDecoration(labelText: 'Goal Type *'),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(true),
                      child: Text(
                        _startDate == null
                            ? 'Start Date *'
                            : DateFormat.yMMMd().format(_startDate!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(false),
                      child: Text(
                        _endDate == null
                            ? 'End Date *'
                            : DateFormat.yMMMd().format(_endDate!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Description *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createCampaign,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Campaign'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _orgController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _targetController.dispose();
    super.dispose();
  }
}
