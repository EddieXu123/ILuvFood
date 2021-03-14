class Customer {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final List favorites;
  final List orderIds;
  Customer(
      {this.uid,
      this.name,
      this.email,
      this.phone,
      this.favorites,
      this.orderIds});
}
