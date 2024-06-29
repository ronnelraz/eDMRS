class MedicalNeedItem {
  final String medcode;
  final String medname;

  MedicalNeedItem({
    required this.medcode, 
    required this.medname,
    });

  factory MedicalNeedItem.fromJson(Map<String, dynamic> json) {
    return MedicalNeedItem(
      medcode: json['med_code'],
      medname: json['med_name'],
    );
  }

}
