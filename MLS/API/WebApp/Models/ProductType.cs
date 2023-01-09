using DAL.Entities.Product.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApp.Models
{
    public class ProductType
    {
        public Guid Id { get; set; }
        public string Name { get; set; }

        public AuditStatusEnum Status { get; set; } = AuditStatusEnum.Active;     

     
    }
}
