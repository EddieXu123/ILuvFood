enum Role { CUSTOMER, BUSINESS }

extension ParseToString on Role {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
