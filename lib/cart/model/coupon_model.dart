class CouponModel {
  final String title;
  final String summary;
  final String status;

  CouponModel({
    required this.title,
    required this.summary,
    required this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'status': status,
    };
  }
}