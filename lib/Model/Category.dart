class Category {
  final int basiccategoryid;
  final String name;
  final String description;
  final int? iconid;

  Category({
    required this.basiccategoryid,
    required this.name,
    required this.description,
    this.iconid,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    basiccategoryid: json['basiccategoryid'],
    name: json['name'],
    description: json['description'],
    iconid: json['iconid'],
  );
}