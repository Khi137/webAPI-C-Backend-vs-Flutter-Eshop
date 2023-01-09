using DAL;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;
using WebApp.Models;
using Invoice = WebApp.Models.Invoice;

namespace WebApp.Controllers
{
    public class InvoiceController : Controller
    {
        public IActionResult Index()
        {
            ViewBag.username = HttpContext.Session.GetString("Username");
            var accessToken = HttpContext.Session.GetString("JWTToken");
            List<Invoice> invoices = new List<Invoice>();           
            using (var item = new HttpClient())
            {
                var endpoint = new Uri("https://localhost:44302/api/Invoice/GetAllInvoices");
                item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                var rs = item.GetAsync(endpoint).Result;
                var json = rs.Content.ReadAsStringAsync().Result;

                invoices = JsonConvert.DeserializeObject<List<Invoice>>(json);
            }
         
            ViewBag.data = invoices;
            return View();
        }

        //public IActionResult Edit(string id)
        //{
        //    var accessToken = HttpContext.Session.GetString("JWTToken");
        //    Invoice invoice = new Invoice();

        //    ViewBag.username = HttpContext.Session.GetString("Username");
        //    using (var item = new HttpClient())
        //    {
        //        var endpoint = new Uri("https://localhost:44302/api/Invoice/GetInvoiceByUserId?id=" + id);
        //        var rs = item.GetAsync(endpoint).Result;
        //        var json = rs.Content.ReadAsStringAsync().Result;
        //        invoice = JsonConvert.DeserializeObject<Invoice>(json);
        //    }
        //    return View();

        //}

        //[HttpPost]
        //public IActionResult Edit([Bind("Id,Status")] Invoice invoice)
        //{
        //    var accessToken = HttpContext.Session.GetString("JWTToken");
        //    Invoice invoices = new Invoice();
        //    using (var item = new HttpClient())
        //    {
        //        var endpoint = new Uri("https://localhost:44302/api/Invoice/GetInvoiceByUserId?id=" + invoice.Id);
        //        var rs = item.GetAsync(endpoint).Result;
        //        var json = rs.Content.ReadAsStringAsync().Result;
        //        invoices = JsonConvert.DeserializeObject<Invoice>(json);
        //    }

        //    invoices.Status = 2;
        //    using (var item = new HttpClient())
        //    {
        //        StringContent content = new StringContent(JsonConvert.SerializeObject(invoices), Encoding.UTF8, "application/json");
        //        var endpoint = new Uri("https://localhost:44302/api/Invoice/UpdateInvoice?id=" + invoice.Id);
        //        item.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        //        var rs = item.PutAsync(endpoint, content).Result;
        //        var json = rs.Content.ReadAsStringAsync().Result;
        //    }

        //    return RedirectToAction("Index");
        //}

    }
}
