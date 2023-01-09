using BLL.Services;
using BLL.ViewModels;
using DAL;
using DAL.Data;
using DAL.Entities.User;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace CKRShop.Controllers
{

        [Route("api/[controller]")]
        [ApiController]
        public class CartController : ControllerBase
        {
            private BLL.Services.CartBLL _BLL;
            private readonly ShopContext _context;
            private readonly UserManager<User> _userManager;

            public CartController(ShopContext context, UserManager<User> userManager)
            {
                _BLL = new CartBLL(context);
                _userManager = userManager;
                _context = context;
            }

            [HttpGet]
            [Route("GetCartByUserId")]
            public IEnumerable<CartModel> GetCartByUserId(string id)
            {
                return _BLL.GetCartByUserId(id);

            }


            [HttpPost] //  POST
            [Route("AddToCart")]           
            public void AddToCart(CartModel CartModel)
            {
                _BLL.AddToCart(CartModel);
            }
            [HttpDelete] //  DELETE
            [Route("DeleteCart")]           
            public void DeleteCart(string id)
            {
                _BLL.DeleteCart(id);

            }
            
            [HttpPut] //  PUT
            [Route("UpdateCart")]
            //[Authorize(Roles = UserRoles.Admin)]
            public void Put(Cart Cart, int id)
            {
                _BLL.UpdateCart(Cart, id);
            }

        }    
}
