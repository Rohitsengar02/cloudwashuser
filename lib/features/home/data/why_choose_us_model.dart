class WhyChooseUsModel {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final bool isActive;

  WhyChooseUsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.isActive,
  });

  factory WhyChooseUsModel.fromJson(Map<String, dynamic> json) {
    return WhyChooseUsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
}
