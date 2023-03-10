const String baseURL = 'https://192.168.1.5:45456/api';
const productsURL = baseURL + '/Product/GetAllProductsIndex';
const productdetailURL = baseURL + '/Product/GetProductById?id=';
const getimageproductURL = baseURL + "/Upload/GetImageProduct?name=";
const getimageuserURL = baseURL + "/Upload/GetImageUser?name=";
const loginURL = baseURL + "/Authenticate/login";
const getUserURL = baseURL + "/User/GetUserByUsername?username=";
const getCartByIDURL = baseURL + "/Cart/GetCartByUserId?id=";
const addToCartURL = baseURL + "/Cart/AddToCart";
const addInvoiceURL = baseURL + "/Invoice/AddInvoice";
const clearCartURL = baseURL + "/Cart/DeleteCart?id=";
const registerURL = baseURL + "/Authenticate/register-customer";
const updatecartURL = baseURL + "/Cart/UpdateCart?id=";
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = ' Something went wrong, try again!';
