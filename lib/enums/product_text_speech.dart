enum ProductTextSpeech {
  ADDTOCART,
  REMOVECART,
  GOTOCART,
  CHECKOUT,
  CONFIRM_CHECKOUT,
  CLEAR_CART,
  ERROR,
  PRODUCT,
}

ProductTextSpeech getFromTextSpeech(String text) {
  switch (text) {
    case "add to cart":
      return ProductTextSpeech.ADDTOCART;
    case "remove from cart":
      return ProductTextSpeech.REMOVECART;
    case "go to cart":
      return ProductTextSpeech.GOTOCART;
    case "checkout":
      return ProductTextSpeech.CHECKOUT;
    case "confirm checkout":
      return ProductTextSpeech.CONFIRM_CHECKOUT;
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
