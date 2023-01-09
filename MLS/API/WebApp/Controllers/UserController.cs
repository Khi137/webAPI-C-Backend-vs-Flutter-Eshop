using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using WebApp.Models;

namespace WebApp.Controllers
{
    public class UserController : Controller
    {


        [HttpGet]
        public IActionResult Index()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/User/GetAllUsers");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                List<User> prodlist = JsonConvert.DeserializeObject<List<User>>(json);
                ViewBag.data = prodlist;
            }
            return View();
        }
       
    }
}
