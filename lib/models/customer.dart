class Customer {
  const Customer({
    required this.id,
    required this.firstname,
    required this.lastname,
  });

  final int id;
  final String firstname;
  final String lastname;

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(id: json['id'], firstname: json['firstname'], lastname: json['lastname']);
  }



  @override
  toString() {
    return '$id $firstname $lastname';
  }


}