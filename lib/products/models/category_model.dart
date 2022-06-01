class CategoryModel {
  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImgUrl,
  });

  factory CategoryModel.fromJson({required Map<String, dynamic> json}) {
    return CategoryModel(
      categoryId: json['catid'] as int,
      categoryName: json['category_name'] as String,
      categoryImgUrl: json['imagedata'] as String,
    );
  }

  final int categoryId;
  final String categoryName;
  final String categoryImgUrl;
}
