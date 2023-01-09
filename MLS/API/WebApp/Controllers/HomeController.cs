using BUS.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Text;
using WebApp.Models;
using System.Net.Http;
using Microsoft.AspNetCore.Identity;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using NuGet.Common;
using Token = WebApp.Models.Token;
using DAL.Entities.User;
using User = WebApp.Models.User;
using System.Data;

namespace WebApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }


        public IActionResult Index()
        {
            var cart = GetCartItems();
            var soluong = cart.Sum(x => x.Quantity);
            HttpContext.Session.SetString("Soluong", soluong.ToString());
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<Product> prodlist = new List<Product>();
            List<byte[]> listimage = new List<byte[]>();
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Product/GetAllProductsIndex");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                prodlist = JsonConvert.DeserializeObject<List<Product>>(json);
            }

            for (int i = 0; i < prodlist.Count; i++)
            {
                using (var sp = new HttpClient())
                {
                    var endpoint = new Uri("https://localhost:44302/api/Upload/GetImageProduct?name=" + prodlist[i].Image);
                    var rs = sp.GetAsync(endpoint).Result;
                    byte[] json = rs.Content.ReadAsByteArrayAsync().Result;
                    listimage.Add(json);
                }
            }
            for (int i = 0; i < prodlist.Count; i++)
            {
                prodlist[i].ImageFile = listimage[i];
            }
            ViewBag.data = prodlist;
            return View();
        }

        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> LoginWithToken(UserLogin user)
        {
            Token listtoken = new Token();
            User userlist = new User();
            List<Roles> rolelist = new List<Roles>();
            string role = "";
            using (var httpClient = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(user), Encoding.UTF8, "application/json");
                using (var response = await httpClient.PostAsync("https://localhost:44302/api/Authenticate/login", content))
                {
                    var token = await response.Content.ReadAsStringAsync();


                    if (token == null)
                    {
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        listtoken = JsonConvert.DeserializeObject<Token>(token);
                        HttpContext.Session.SetString("JWTToken", listtoken.token);
                        HttpContext.Session.SetString("Username", user.Username);
                    }

                }



                using (var item = new HttpClient())
                {
                    var endpoint = new Uri("https://localhost:44302/api/User/GetUserByUsername?username=" + user.Username);
                    var rs = item.GetAsync(endpoint).Result;
                    var json = rs.Content.ReadAsStringAsync().Result;
                    userlist = JsonConvert.DeserializeObject<User>(json);
                    if (userlist.EmailConfirmed == false)
                    {
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        using (var item2 = new HttpClient())
                        {
                            var endpoint2 = new Uri("https://localhost:44302/api/Authenticate/GetAllRoles");
                            var rs2 = item2.GetAsync(endpoint2).Result;
                            var json2 = rs2.Content.ReadAsStringAsync().Result;

                            rolelist = JsonConvert.DeserializeObject<List<Roles>>(json2);
                        }
                        for (int i = 0; i < rolelist.Count; i++)
                        {
                            if (rolelist[i].Id == userlist.Role)
                            {
                                role = rolelist[i].Name;
                            }
                        }

                        if (role.ToUpper() == "ADMIN" || role.ToUpper() == "STAFF")
                        {
                            return RedirectToAction("Index", "Product");

                        }
                        else
                        {
                            return RedirectToAction("Index");
                        }
                    }
                }

                return View();

            }
        }
        public IActionResult RegisterCustomer()
        {
            return View();
        }
        [HttpPost]
        public async Task<IActionResult> RegisterCustomer(User user)
        {
            using (var httpClient = new HttpClient())
            {
                string role = "";
                string avatar = "";
                StringContent content = new StringContent(JsonConvert.SerializeObject(user), Encoding.UTF8, "application/json");
                using (var response = await httpClient.PostAsync("https://localhost:44302/api/Authenticate/register-customer", content))
                {
                    var rs = await response.Content.ReadAsStringAsync();
                    var mess = JsonConvert.DeserializeObject<LoginMessage>(rs);
                    if (mess.message == "Email already exists!")
                    {
                        return RedirectToAction("RegisterCustomer");
                    }
                }

                return RedirectToAction("Login");
            }
        }

        public IActionResult Logout()
        {
            HttpContext.Session.Remove("Username");
            HttpContext.Session.Remove("JWTToken");
            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult Detail(string id)
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            Product product = new Product();
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/ProductType/GetAllProductTypes");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                List<ProductType> prodlist = JsonConvert.DeserializeObject<List<ProductType>>(json);
                ViewBag.data = prodlist;
            }
            ViewBag.username = HttpContext.Session.GetString("Username");
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Product/GetProductById?id=" + id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                product = JsonConvert.DeserializeObject<Product>(json);
            }

            using (var sp = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Upload/GetImageProduct?name=" + product.Image);
                var rs = sp.GetAsync(endpoint).Result;
                byte[] json = rs.Content.ReadAsByteArrayAsync().Result;
                product.ImageFile = json;
            }
            HttpContext.Session.SetString("ImageProduct", product.Image);
            ViewBag.product = product;

            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/ProductType/GetProductTypeById?id=" + product.ProductTypeId);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                ProductType producttype = JsonConvert.DeserializeObject<ProductType>(json);
                ViewBag.producttype = producttype;
            }
            return View();
        }




        public IActionResult AddInvoice(string id)
        {
            ViewBag.total = id;
            return View();
        }


        [HttpPost]
        public async Task<IActionResult> AddInvoice([Bind("UserId,ShippingAddress,ShippingPhone,Total")] Invoice invoice)
        {

            User usercurrent = new User();
            string username = HttpContext.Session.GetString("Username");
            int idhd = 0;
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/User/GetUserByUsername?username=" + username);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
                usercurrent = JsonConvert.DeserializeObject<User>(json);
                invoice.UserId = usercurrent.Id;
            }
      
            using (var httpClient = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(invoice), Encoding.UTF8, "application/json");
                using (var response = await httpClient.PostAsync("https://localhost:44302/api/Invoice/AddInvoice", content))
                {
                    var token = await response.Content.ReadAsStringAsync();
                }
            }
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Invoice/GetAllInvoices");
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
                List<Invoice> lsinvoice = JsonConvert.DeserializeObject<List<Invoice>>(json);
                if (lsinvoice.Count > 0)
                {
                    int finalrs = lsinvoice.Max(p => p.Id);
                    idhd = finalrs;
                }
            }
            List<Cart> cart = GetCartItems();
            InvoiceDetail invoicedetail = new InvoiceDetail(); 
           for(int i = 0;i<cart.Count;i++)
            {
               invoicedetail.ProductId = cart[i].ProductId;
               invoicedetail.Quantity = cart[i].Quantity;
               invoicedetail.UnitPrice = cart[i].Price;
               invoicedetail.InvoiceId = idhd;
                using (var httpClient = new HttpClient())
                {
                    StringContent content = new StringContent(JsonConvert.SerializeObject(invoicedetail), Encoding.UTF8, "application/json");
                    using (var response = await httpClient.PostAsync("https://localhost:44302/api/InvoiceDetail/AddInvoiceDetail", content))
                    {
                        var token = await response.Content.ReadAsStringAsync();
                    }
                   
                }
            }
            ClearCart();

            return RedirectToAction("Index");
        }
        public IActionResult AddInvoiceDetails()
        {
            return RedirectToAction("Index");
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult AddToCart(Guid Id)
        {

            ViewBag.username = HttpContext.Session.GetString("Username");
            List<byte[]> listimage = new List<byte[]>();
            Product prod = new Product();           
            using (var item = new HttpClient())
            {
                var endpoint = new Uri(" https://localhost:44302/api/Product/GetProductById?id="+Id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
                prod = JsonConvert.DeserializeObject<Product>(json);
            }          

            ViewBag.data = prod;
            


            int tongtien = 0;
            // Xử lý đưa vào Cart ...
            List<Cart> cart = GetCartItems();
            var soluong = cart.Sum(x => x.Quantity);
            HttpContext.Session.SetString("Soluong", soluong.ToString());
            var cartitem = cart.Find(p => p.ProductId == Id);
            if (cartitem != null)
            {
                // Đã tồn tại, tăng thêm 1
                cartitem.Quantity++;

            }
            else
            {


                //  Thêm mới

                    using (var sp = new HttpClient())
                    {
                        var endpoint = new Uri("https://localhost:44302/api/Upload/GetImageProduct?name=" + prod.Image);
                        var rs = sp.GetAsync(endpoint).Result;
                        byte[] image = rs.Content.ReadAsByteArrayAsync().Result;
                        cart.Add(new Cart() { Quantity = 1, ProductId = Id, ProductName = prod.Name, Price = prod.Price,ImageFile = image });
                    }

                
               
            }

          

            // Lưu cart vào Session
            SaveCartSession(cart);
            // Chuyển đến trang hiện thị Cart
            return RedirectToAction(nameof(Index));


            // Xử lý đưa vào Cart ...


            return RedirectToAction(nameof(Cart));
        }
        /// xóa item trong cart
        public IActionResult RemoveCart( int Id)
        {
            var cart = GetCartItems();
            var cartitem = cart.Find(p => p.Id == Id);
            if (cartitem != null)
            {
                // Đã tồn tại, tăng thêm 1
                cart.Remove(cartitem);
            }

            SaveCartSession(cart);

            // Xử lý xóa một mục của Cart ...
            return RedirectToAction(nameof(Cart));
        }

        /// Cập nhật

        [HttpPost]
        public IActionResult UpdateCart( int productid, int quantity)
        {
            var cart = GetCartItems();
             var soluong = cart.Sum(x => x.Quantity);
            HttpContext.Session.SetString("Soluong", soluong.ToString());
            var cartitem = cart.Find(p => p.Id == productid);
            if (cartitem != null)
            {
                // Đã tồn tại, tăng thêm 1
                cartitem.Quantity = quantity;
            }
           
            SaveCartSession(cart);
            // Trả về mã thành công (không có nội dung gì - chỉ để Ajax gọi)
            return Ok();
        }


        // Hiện thị giỏ hàng
        public IActionResult Cart()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            return View(GetCartItems());
        }

        public IActionResult CheckOut()
        {
            // Xử lý khi đặt hàng
            return View();
        }
        public const string CARTKEY = "cart";

        // Lấy cart từ Session (danh sách CartItem)
        List<Cart> GetCartItems()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var session = HttpContext.Session;
            string jsoncart = session.GetString(CARTKEY);
            if (jsoncart != null)
            {
                return JsonConvert.DeserializeObject<List<Cart>>(jsoncart);
            }
            return new List<Cart>();
        }

        // Xóa cart khỏi session
        void ClearCart()
        {

            var session = HttpContext.Session;
            session.Remove(CARTKEY);
        }

        // Lưu Cart (Danh sách CartItem) vào session
        void SaveCartSession(List<Cart> ls)
        {
            
            var session = HttpContext.Session;
            string jsoncart = JsonConvert.SerializeObject(ls);
            session.SetString(CARTKEY, jsoncart);
        }

    }
}