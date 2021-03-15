class Business {
  final String uid;
  final String businessName;
  final String address;
  final String lat;
  final String lng;
  final String phone;
  final String image;
  final List orderIds;
  final bool isOpen;
  Business(
      {this.uid,
      this.businessName,
      this.address,
      this.image,
      this.lat,
      this.lng,
      this.phone,
      this.orderIds,
      this.isOpen});
}
