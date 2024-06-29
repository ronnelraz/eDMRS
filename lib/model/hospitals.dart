class HospitalsItem {
  final String hospitalcode;
  final String hospitalfname;
  final String hospitalsname;

  HospitalsItem({
    required this.hospitalcode, 
    required this.hospitalfname,
    required this.hospitalsname,
    });

  factory HospitalsItem.fromJson(Map<String, dynamic> json) {
    return HospitalsItem(
      hospitalcode: json['hospital_code'],
      hospitalfname: json['HOSPITAL_LNAME'],
      hospitalsname: json['HOSPITAL_SNAME'],
    );
  }

}
