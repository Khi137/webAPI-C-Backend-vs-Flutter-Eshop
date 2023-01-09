using DAL.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL
{
    public class WishlistDAL
    {
        private readonly ShopContext _context;
        public WishlistDAL(ShopContext context)
        {
            _context = context;
        }
        public IEnumerable<Wishlist> GetAllWishlists(string userId)
        {
            return _context.Wishlists.Include(p => p.Product).Where(cmt => cmt.Status !=99 && cmt.UserId == userId).ToList();

        }

        public void AddWishlist(Wishlist Wishlist)
        {
            _context.Wishlists.Add(Wishlist);
            _context.SaveChanges();        
        }

        public void DeleteWishlist(Wishlist Wishlist)
        {
            Wishlist.Status = 99;
            _context.Wishlists.Update(Wishlist);
            _context.SaveChanges();
        }

    }
}
