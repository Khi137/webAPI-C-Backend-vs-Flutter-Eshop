using DAL.Entities.Product.Enums;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApp.Models
{
    public class Product
    {
        public Guid Id { get; set; }
        public string SKU { get; set; } = string.Empty;  
        public string Name { get; set; } = string.Empty; 
        public string Branch { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int Price { get; set; } = 0;
        public int Stock { get; set; } = 0;
        public Guid ProductTypeId { get; set; }
        public ProductType ProductType { get; set; }
        public string Image { get; set; }
        public DateTime CreatedAt { get; set; }
        public StatusEnum Status { get; set; }
        public IFormFile FileImage { get; set; }
        public byte[] ImageFile { get; set; }



    }
}
