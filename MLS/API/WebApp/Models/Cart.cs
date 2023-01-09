using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL.Entities.Product;
using DAL.Entities.User;

namespace WebApp.Models
{
    public class Cart
    {
        public int Id { get; set; }

        public string UserId { get; set; }
        public Guid ProductId { get; set; }
        public string ProductName { get; set; }
        public string ShippingAddress { get; set; }
        public string ShippingPhone { get; set; }
        public string Image { get; set; }
        public byte[] ImageFile { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; } = 1;
        public int Total { get; set; }
    }
}
