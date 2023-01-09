using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;
using WebApp.Models;

namespace WebApp.Controllers
{
    public class ProductTypeController : Controller
    {

        [HttpGet]
        public IActionResult Index()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/ProductType/GetAllProductTypes");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                List<ProductType> prodlist = JsonConvert.DeserializeObject<List<ProductType>>(json);
                ViewBag.data = prodlist;
            }
            return View();
        }

        [HttpPost]
        public IActionResult Create(ProductType productType)
        {
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<ProductType> prodlist = new List<ProductType>();            
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(productType), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/ProductType/AddProductType");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.PostAsync(endpoint, content).Result;

                return RedirectToAction(nameof(Index));
            }
            return View();

        }

        public IActionResult Create()
        {      
            return View();
        }
        public IActionResult Edit( string id)
        {       
            ViewBag.username = HttpContext.Session.GetString("Username");          
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/ProductType/GetProductTypeById?id=" + id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                ProductType producttype = JsonConvert.DeserializeObject<ProductType>(json);
                ViewBag.producttype = producttype;
            }
            return View();
        }

        [HttpPost]
        public IActionResult Edit([Bind("Id,Name")] ProductType productType)
        {
           
            var accessToken = HttpContext.Session.GetString("JWTToken");          
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(productType), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/ProductType/UpdateProductType?Id=" + productType.Id);
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.PutAsync(endpoint, content).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
            }

            return RedirectToAction("Index");
        }

    }
}
