class DeliveryDetailModel {

  String? startingPin;
  String? endingPin;
  String? time;
  String? state;

  DeliveryDetailModel({
    this.startingPin,
    this.endingPin,
    this.time,
    this.state,
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDetailModel(
      startingPin: json['starting_pin'] != null ? json['starting_pin'].toString() : '',
      endingPin: json['ending_pin'] != null ? json['ending_pin'].toString() : '',
      time: json['time'] != null ? json['time'].toString() : '',
      state: json['state'] != null ? json['state'].toString() : '',
    );
  }

}