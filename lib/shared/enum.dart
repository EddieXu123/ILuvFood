enum Role { CUSTOMER, BUSINESS, UNDEFINED }

extension ParseToString on Role {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

// enum STATUS { CONFIRMED, PACKING, READY, DELIVERED}

// extension ParseStatusToString on STATUS {
//   String toShortString() {
//     return this.toString().split('.').last;
//   }
// }