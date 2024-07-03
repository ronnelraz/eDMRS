class DependentsItem {
  final String dependentName;
  final String dependentRelation;

  DependentsItem({
    required this.dependentName, 
    required this.dependentRelation,
    });

  factory DependentsItem.fromJson(Map<String, dynamic> json) {
    return DependentsItem(
      dependentName: json['dependent_name'],
      dependentRelation: json['dependent_relation'],
    );
  }

}
