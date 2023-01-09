using DAL.Entities.Product;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;
using WebApp.Models;
using ProductType = WebApp.Models.ProductType;

namespace WebApp.Controllers
{
    public class TradeMarkController : Controller
    {


        [HttpGet]
        public IActionResult Index()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/TradeMark/GetAllTradeMarks");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                List<TradeMark> trademarklist = JsonConvert.DeserializeObject<List<TradeMark>>(json);
                ViewBag.data = trademarklist;
            }
            return View();
        }
        [HttpPost]
        public IActionResult Create(TradeMark tradeMark)
        {
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<TradeMark> prodlist = new List<TradeMark>();
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(tradeMark), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/TradeMark/AddTradeMark");
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

        public IActionResult Edit(string id)
        {
            using (var item = new HttpClient())
            {
                ViewBag.username = HttpContext.Session.GetString("Username");

                TradeMark tradeMark = new TradeMark();

                var endpoint = new Uri("https://localhost:44302/api/ProductType/GetProductTypeById?id=" + tradeMark.Id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                ProductType producttype = JsonConvert.DeserializeObject<ProductType>(json);
                ViewBag.producttype = producttype;
            }
          
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/TradeMark/GetTradeMarkByProductTypeId?id=" + id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
                TradeMark tradeMark = JsonConvert.DeserializeObject<TradeMark>(json);
                ViewBag.producttype = tradeMark;
            }
            return View();
        }

        [HttpPost]
        public IActionResult Edit([Bind("Id,Name")] TradeMark tradeMark)
        {

            var accessToken = HttpContext.Session.GetString("JWTToken");
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(tradeMark), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/TradeMark/UpdateTradeMark?Id=" + tradeMark.Id);
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.PutAsync(endpoint, content).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
            }

            return RedirectToAction("Index");

        }
    }
}
