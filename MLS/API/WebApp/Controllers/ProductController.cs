using DAL.Data;
using DAL.Entities.Product;
using DAL.Entities.User;

using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Resources;
using System.Text;
using WebApp.Models;
using Product = WebApp.Models.Product;
using ProductType = WebApp.Models.ProductType;

namespace WebApp.Controllers
{
    public class ProductController : Controller
    {
        private readonly IWebHostEnvironment _hostEnvironment;
        public ProductController(IWebHostEnvironment hostEnvironment)
        {

            _hostEnvironment = hostEnvironment;
        }

        [HttpGet]
        public IActionResult Index()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<Product> prodlist = new List<Product>();
            List<byte[]> listimage = new List<byte[]>();
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Product/GetAllProducts");
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
        [HttpPost]
        public IActionResult Create([Bind("Name,SKU,Description,Price,Stock,ProductTypeId,FileImage")] Product product)
        {
            if (product.FileImage != null)
            {
                var fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + Path.GetExtension(product.FileImage.FileName);
                var uploadPath = "..\\..\\..\\MLS\\API\\CKRShop\\Resources\\Images\\Products";
                var filePath = Path.Combine(uploadPath, fileName);
                using (FileStream fs = System.IO.File.Create(filePath))
                {
                    product.FileImage.CopyTo(fs);
                    fs.Flush();
                }
                product.Image = fileName;
                var accessToken = HttpContext.Session.GetString("JWTToken");
                List<Product> prodlist = new List<Product>();
                using (var item = new HttpClient())
                {
                    StringContent content = new StringContent(JsonConvert.SerializeObject(product), Encoding.UTF8, "application/json");
                    var endpoint = new Uri("https://localhost:44302/api/Product/AddProduct");
                    item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                    var rs = item.PostAsync(endpoint, content).Result;

                    return RedirectToAction(nameof(Index));
                }
            }
            return View();
        }



        public IActionResult Create()
        {
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
        public IActionResult Edit(string id)
        {
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
                var endpoint = new Uri("https://localhost:44302/api/Product/GetProductById?id="+ id);
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
        [HttpPost]
        public IActionResult Edit([Bind("Id,Name,SKU,Description,Price,Stock,ProductTypeId,FileImage,Status")] Product product)
        {
            string imageproduct = HttpContext.Session.GetString("ImageProduct");
            product.Image = imageproduct;
            var accessToken = HttpContext.Session.GetString("JWTToken");
            if (product.FileImage != null)
            {
                var fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + Path.GetExtension(product.FileImage.FileName);
                var uploadPath = "..\\..\\..\\MLS\\API\\CKRShop\\Resources\\Images\\Products";
                var filePath = Path.Combine(uploadPath, fileName);
                using (FileStream fs = System.IO.File.Create(filePath))
                {
                    product.FileImage.CopyTo(fs);
                    fs.Flush();
                }
                product.Image = fileName;
               
            }
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(product), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/Product/UpdateProduct?Id=" + product.Id);
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.PutAsync(endpoint, content).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
            }

            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult Detail(string id)
        {

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



        public IActionResult Delete(string id)
        {          
                var accessToken = HttpContext.Session.GetString("JWTToken");
                Product product = new Product();
               
                ViewBag.username = HttpContext.Session.GetString("Username");
                using (var item = new HttpClient())
                {
                    var endpoint = new Uri("https://localhost:44302/api/Product/GetProductById?id=" + id);
                    var rs = item.GetAsync(endpoint).Result;
                    var json = rs.Content.ReadAsStringAsync().Result;
                    product = JsonConvert.DeserializeObject<Product>(json);
                }              
                return View();
          
        }

        [HttpPost]
        public IActionResult Delete([Bind("Id,Name,SKU,Description,Price,Stock,ProductTypeId,Status")] Product product)
        {         
            var accessToken = HttpContext.Session.GetString("JWTToken");
            Product prod = new Product();            
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Product/GetProductById?id=" + product.Id);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
                prod = JsonConvert.DeserializeObject<Product>(json);
            }
            prod.Status = DAL.Entities.Product.Enums.StatusEnum.Deleted;
            using (var item = new HttpClient())
            {
                StringContent content = new StringContent(JsonConvert.SerializeObject(prod), Encoding.UTF8, "application/json");
                var endpoint = new Uri("https://localhost:44302/api/Product/UpdateProduct?id=" + product.Id);
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.PutAsync(endpoint, content).Result;
                var json = rs.Content.ReadAsStringAsync().Result;
            }         
            
            return RedirectToAction("Index");
        }

        [HttpGet]
        public IActionResult AdminTrash()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<Product> prodlist = new List<Product>();
            List<byte[]> listimage = new List<byte[]>();
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Product/GetAllProductsRemove");
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
    }
}
