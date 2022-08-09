/// [CategoriesType] for managing categories of products.
// ignore_for_file: constant_identifier_names

enum CategoriesType {
  ///[CategoriesType.ETHICAL] for ethcial products.
  ETHICAL,

  ///[CategoriesType.GENERIC] forgeneric products.
  GENERIC,

  ///[CategoriesType.SURGICAL] for sugical products.
  SURGICAL,

  ///[CategoriesType.VETERINARY] for veterinary products.
  VETERINARY,

  ///[CategoriesType.AYURVEDIC] for ayurvedic products.
  AYURVEDIC,

  ///[CategoriesType.GENERAL] for general products.
  GENERAL,
}

extension CategoriesTypeExtenstion on CategoriesType {
  String categoryString() {
    switch (this) {
      case CategoriesType.ETHICAL:
        return 'Ethical';
      case CategoriesType.GENERIC:
        return 'Generic';
      case CategoriesType.SURGICAL:
        return 'Surgical';
      case CategoriesType.VETERINARY:
        return 'Veterinary';
      case CategoriesType.AYURVEDIC:
        return 'Ayurvedic';
      case CategoriesType.GENERAL:
        return 'General';
    }
  }
}

CategoriesType categoriesfromValue(String category) {
  switch (category) {
    case 'Ethical':
      return CategoriesType.ETHICAL;
    case 'Generic':
      return CategoriesType.GENERIC;
    case 'Surgical':
      return CategoriesType.SURGICAL;
    case 'Veterinary':
      return CategoriesType.VETERINARY;
    case 'Ayurvedic':
      return CategoriesType.AYURVEDIC;
    case 'General':
      return CategoriesType.GENERAL;
    default:
      return CategoriesType.GENERAL;
  }
}
