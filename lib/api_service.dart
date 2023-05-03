// ----------------------------------------------------------- PRODUCTION APIS ------------------------------------------------------------------//

// --------------------- Version URL ----------------------------------//
const versionUrl = 'https://api.medrpha.com/api/Default/latestappversion';

// --------------------- Products URL ---------------------------------//
const categoryUrl = 'https://api.medrpha.com/api/product/getcategory';
const productsUrl = 'https://api.medrpha.com/api/product/productlist';
const productDetailsUrl = 'https://api.medrpha.com/api/product/productdetails';
const updateProductQuantityUrl =
    'https://api.medrpha.com/api/cart/updatequantity';
const addToCartUrl = 'https://api.medrpha.com/api/cart/addtocart';
const getCartUrl = 'https://api.medrpha.com/api/cart/viewcart';
const removeCartUrl = 'https://api.medrpha.com/api/cart/deletecart';
const plusCart = 'https://api.medrpha.com/api/cart/cartplus';
const minusCart = 'https://api.medrpha.com/api/cart/cartminus';
const checkoutUrl = 'https://medrpha.com/api/checkout/checkout';
const ordersPayment = 'https://api.razorpay.com/v1/orders';
const paymentConfirmUrl = 'https://medrpha.com/api/order/payconfirmed';
const checkoutConfirmUrl = 'https://medrpha.com/api/checkout/checkoutconfirm';

// ---------------------- Profile URL -----------------------------------//
const getProfileUrl = 'https://api.medrpha.com/api/profile/getprofile';
const uploadProfileUrl = 'https://api.medrpha.com/api/register/register';
const uploadDLUrl = 'https://api.medrpha.com/api/register/registerdlno';
const uploadGSTUrl = 'https://api.medrpha.com/api/register/registergstno';
const countryUrl = 'https://api.medrpha.com/api/register/getcountryall';
const stateUrl = 'https://api.medrpha.com/api/register/getstateall';
const uploadFssaiUrl = 'https://api.medrpha.com/api/register/registerfssai';
const cityUrlAll = 'https://api.medrpha.com/api/register/getcityall';
const cityUrlSingle = 'https://api.medrpha.com/api/register/getcity';
const areaUrlAll = 'https://api.medrpha.com/api/register/getpincodeall';
const areaUrlSingle = 'https://api.medrpha.com/api/register/getpincode';
const fssaiImgUrl = 'https://medrpha.com/api/register/registerfssaiimg';
const dl1ImgUrl = 'https://medrpha.com/api/register/registerdl1';
const dl2ImgUrl = 'https://medrpha.com/api/register/registerdl2';
const gstNoDelete = 'https://api.medrpha.com/api/register/registergstnodelete';
const fssaiNoDelete =
    'https://api.medrpha.com/api/register/registerfssaidelete';

// ------------------------------ Order History URL ------------------------------//
const orderUrl = 'https://api.medrpha.com/api/order/orderlist';
const ordersListUrl = 'https://api.medrpha.com/api/order/orderdetail';
const cancelOrderUrl = 'https://api.medrpha.com/api/order/ordercancel';

// ------------------------------ Login/SignUp URL ------------------------------ //
const getOTPUrl = 'https://api.medrpha.com/api/Default/sendotp';
const checkOTPUrl = 'https://api.medrpha.com/api/Default/otpverify';
const checkStatus = 'https://api.medrpha.com/api/Default/userstatus';

//------------------------------- Micellenous URL -------------------------------//
const catImgUrl = 'https://superadmin.medrpha.com/allimage/';
const productUrl = 'https://partner.medrpha.com/product_image/';
const licenseUrl = 'https://medrpha.com/user_reg/';
const invoiceUrl = 'https://medrpha.com/InvoicePDF/';
const apiKey = 'rzp_live_kfbonxeuRfZYaL';
const apiSecretKey = '1fdFnhoGt47VZlhDha7KkMaR';

// // ----------------------------------------------------------- TEST APIS ------------------------------------------------------------------//

// // --------------------- Version URL ----------------------------------//
// const versionUrl = 'https://apitest.medrpha.com/api/Default/latestappversion';

// // --------------------- Products URL ---------------------------------//
// const categoryUrl = 'https://apitest.medrpha.com/api/product/getcategory';
// const productsUrl = 'https://apitest.medrpha.com/api/product/productlist';
// const productDetailsUrl =
//     'https://apitest.medrpha.com/api/product/productdetails';
// const updateProductQuantityUrl =
//     'https://apitest.medrpha.com/api/cart/updatequantity';
// const addToCartUrl = 'https://apitest.medrpha.com/api/cart/addtocart';
// const getCartUrl = 'https://apitest.medrpha.com/api/cart/viewcart';
// const removeCartUrl = 'https://apitest.medrpha.com/api/cart/deletecart';
// const plusCart = 'https://apitest.medrpha.com/api/cart/cartplus';
// const minusCart = 'https://apitest.medrpha.com/api/cart/cartminus';
// const checkoutUrl = 'https://test.medrpha.com/api/checkout/checkout';
// const ordersPayment = 'https://api.razorpay.com/v1/orders';
// const paymentConfirmUrl = 'https://test.medrpha.com/api/order/payconfirmed';
// const checkoutConfirmUrl =
//     'https://test.medrpha.com/api/checkout/checkoutconfirm';

// // ---------------------- Profile URL -----------------------------------//
// const getProfileUrl = 'https://apitest.medrpha.com/api/profile/getprofile';
// const uploadProfileUrl = 'https://apitest.medrpha.com/api/register/register';
// const uploadDLUrl = 'https://apitest.medrpha.com/api/register/registerdlno';
// const uploadGSTUrl = 'https://apitest.medrpha.com/api/register/registergstno';
// const countryUrl = 'https://apitest.medrpha.com/api/register/getcountryall';
// const stateUrl = 'https://apitest.medrpha.com/api/register/getstateall';
// const uploadFssaiUrl = 'https://apitest.medrpha.com/api/register/registerfssai';
// const cityUrlAll = 'https://apitest.medrpha.com/api/register/getcityall';
// const cityUrlSingle = 'https://apitest.medrpha.com/api/register/getcity';
// const areaUrlAll = 'https://apitest.medrpha.com/api/register/getpincodeall';
// const areaUrlSingle = 'https://apitest.medrpha.com/api/register/getpincode';
// const fssaiImgUrl = 'https://test.medrpha.com/api/register/registerfssaiimg';
// const dl1ImgUrl = 'https://test.medrpha.com/api/register/registerdl1';
// const dl2ImgUrl = 'https://test.medrpha.com/api/register/registerdl2';
// const gstNoDelete =
//     'https://apitest.medrpha.com/api/register/registergstnodelete';
// const fssaiNoDelete =
//     'https://apitest.medrpha.com/api/register/registerfssaidelete';

// // ------------------------------ Order History URL ------------------------------//
// const orderUrl = 'https://apitest.medrpha.com/api/order/orderlist';
// const ordersListUrl = 'https://apitest.medrpha.com/api/order/orderdetail';
// const cancelOrderUrl = 'https://apitest.medrpha.com/api/order/ordercancel';

// // ------------------------------ Login/SignUp URL ------------------------------ //
// const getOTPUrl = 'https://apitest.medrpha.com/api/Default/sendotp';
// const checkOTPUrl = 'https://apitest.medrpha.com/api/Default/otpverify';
// const checkStatus = 'https://apitest.medrpha.com/api/Default/userstatus';

// //------------------------------- Micellenous URL -------------------------------//
// const catImgUrl = 'https://superadmintest.medrpha.com/allimage/';
// const productUrl = 'https://partnertest.medrpha.com/product_image/';
// const licenseUrl = 'https://test.medrpha.com/user_reg/';
// const invoiceUrl = 'https://test.medrpha.com/InvoicePDF/';
// const apiKey = 'rzp_test_3mRxTObsNw167K';
// const apiSecretKey = 'i67GTEvHsJpSIkAKcM3etMRh';
