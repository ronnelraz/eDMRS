class SubMenuItem {
  final String subCode;
  final String fname;
  final String sname;
  final String balCode;
  final String urlImg;

  SubMenuItem({
    required this.subCode, 
    required this.fname, 
    required this.sname, 
    required this.balCode,
    required this.urlImg
    });

  factory SubMenuItem.fromJson(Map<String, dynamic> json) {
    return SubMenuItem(
      subCode: json['sub_code'],
      fname: json['fname'],
      sname: json['sname'],
      balCode: json['bal_code'],
      urlImg: json['urlImg'],
    );
  }

}
