class UserModel {
  String? name;
  String? contact;
  String? alternateContact;
  String? pincode;
  String? city;
  String? state;
  String? country;
  String? address;
  String? stateCode;
  List<String>? crops;
  String? farmArea;

  UserModel({
    this.name,
    this.contact,
    this.alternateContact,
    this.pincode,
    this.city,
    this.state,
    this.country,
    this.address,
    this.stateCode,
    this.crops,
    this.farmArea,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      alternateContact: json['alternateContact'] ?? '',
      pincode: json['pincode'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      address: json['address'] ?? '',
      stateCode: json['stateCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'alternateContact': alternateContact,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': country,
      'address': address,
      'stateCode': stateCode,
    };
  }
}
