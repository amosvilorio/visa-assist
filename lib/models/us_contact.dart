class UsContact {
  final String contactName;
  final String organizationName;
  final String relationship;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String phoneNumber;
  final String email;

  const UsContact({
    this.contactName = '',
    this.organizationName = '',
    this.relationship = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.phoneNumber = '',
    this.email = '',
  });

  UsContact copyWith({
    String? contactName,
    String? organizationName,
    String? relationship,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? phoneNumber,
    String? email,
  }) {
    return UsContact(
      contactName: contactName ?? this.contactName,
      organizationName:
      organizationName ?? this.organizationName,
      relationship: relationship ?? this.relationship,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contactName': contactName,
      'organizationName': organizationName,
      'relationship': relationship,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory UsContact.fromMap(Map<String, dynamic> map) {
    return UsContact(
      contactName: map['contactName'] ?? '',
      organizationName: map['organizationName'] ?? '',
      relationship: map['relationship'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
    );
  }
}