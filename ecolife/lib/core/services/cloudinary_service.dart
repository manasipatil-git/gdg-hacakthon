class CloudinaryService {
  /// Mock image upload – returns a placeholder image URL
  static Future<String?> pickAndUploadImage() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // High-quality placeholder images
    final placeholders = [
      'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800&q=80',
      'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800&q=80',
      'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800&q=80',
      'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800&q=80',
      'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&q=80',
    ];

    return placeholders[
      DateTime.now().millisecondsSinceEpoch % placeholders.length
    ];
  }
}
