enum ProductTextSpeech {
  ADDTOCART,
  REMOVECART,
  ERROR,
  PRODUCT,
  GOTOCART,
  CLEAR_CART,
}

ProductTextSpeech getFromTextSpeech(String text) {
  switch (text) {
    case "add to cart":
      return ProductTextSpeech.ADDTOCART;
    case "card mein add":
      return ProductTextSpeech.ADDTOCART;
    case "product add kare":
      return ProductTextSpeech.ADDTOCART;
    case "product nikaliye":
      return ProductTextSpeech.REMOVECART;
    case "remove from cart":
      return ProductTextSpeech.REMOVECART;
    case "go to cart":
      return ProductTextSpeech.GOTOCART;
    case "empty cart":
      return ProductTextSpeech.CLEAR_CART;
    case "clear cart":
      return ProductTextSpeech.CLEAR_CART;
    case "":
      return ProductTextSpeech.ERROR;
    default:
      return ProductTextSpeech.PRODUCT;
  }
}
