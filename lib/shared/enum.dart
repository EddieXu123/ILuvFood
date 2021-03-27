enum Role { CUSTOMER, BUSINESS, UNDEFINED }

extension ParseToString on Role {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

enum Status { CONFIRMED, PACKING, READY, DELIVERED}

extension ParseStatusToString on Status {
  String toShortString() {
    return this.toString().split('.').last;
  }
}