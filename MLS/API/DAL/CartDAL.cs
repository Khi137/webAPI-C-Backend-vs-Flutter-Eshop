using DAL.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL
{
    public class CartDAL
    {

        private readonly ShopContext _context;
        public CartDAL(ShopContext context)
        {
            _context = context;
        }

        public IEnumerable<Cart> GetCartByUserId(string id)
        {
            return _context.Carts.Where(x => x.UserId == id).ToList();
        }

            public void AddToCart(Cart cart)
        {          
            _context.Carts.Add(cart);
            _context.SaveChanges();
        }
        public void DeleteCart(Cart cart)
        {
            _context.Carts.Remove(cart);
            _context.SaveChanges();
        }
        public void UpdateCart(Cart cart, Cart CartCurrent)
        {
            CartCurrent.Quantity = cart.Quantity;
            _context.SaveChanges();
        }
    }
}
