enum Role { CUSTOMER, BUSINESS, UNDEFINED }

extension ParseToString on Role {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
