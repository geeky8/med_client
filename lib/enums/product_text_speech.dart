enum ProductTextSpeech {
  ADDTOCART,
  REMOVECART,
  ERROR,
  PRODUCT,
}

ProductTextSpeech getFromTextSpeech(String text) {
  switch (text) {
    case "add to cart":
      return ProductTextSpeech.ADDTOCART;
    case "remove from cart":
      return ProductTextSpeech.REMOVECART;
    case "":
      return ProductTextSpeech.ERROR;
    default:
      return ProductTextSpeech.PRODUCT;
  }
}
