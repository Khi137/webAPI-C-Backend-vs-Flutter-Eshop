using AutoMapper;
using DAL.Data;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.ViewModels;

namespace BLL.Services
{
    public class CartBLL
    {    
            private readonly CartDAL _DAL;
            private readonly Mapper _CartMapper;
            private readonly ShopContext _context;

            /// <summary>
            /// Constructor init config mapper, new UserDAL
            /// </summary>
            /// <param name="context"></param>
            public CartBLL(ShopContext context)
            {
                _DAL = new CartDAL(context);
                var _configUser = new MapperConfiguration(cfg => cfg.CreateMap<Cart, CartModel>().ReverseMap());

                _CartMapper = new Mapper(_configUser);
                _context = context;
            }
        public IEnumerable<CartModel> GetCartByUserId(string id)
        {
            // Mapper
            var Cart = _DAL.GetCartByUserId(id);
            IEnumerable<CartModel> CartModel = _CartMapper.Map<IEnumerable<Cart>, IEnumerable<CartModel>>(Cart);
            return CartModel;
        }
        public void AddToCart(CartModel CartModel)
        {
            //DAL add user => Mapper reverse Usermodel => user
            Cart userEntity = _CartMapper.Map<CartModel, Cart>(CartModel);
            _DAL.AddToCart(userEntity);
        }
        public CartModel DeleteCart(string id)
        {

            List<Cart> listcart = _context.Carts.Where(x => x.UserId == id).ToList();
            if (listcart == null)
            {
                throw new Exception("Invalid ID");
            }

            foreach(var item in listcart)
            {
                _DAL.DeleteCart(item);
            }

            Cart cart = _context.Carts.FirstOrDefault(x => x.UserId == id);
            CartModel CartModel = _CartMapper.Map<Cart, CartModel>(cart);
            return CartModel;
        }       
        public CartModel UpdateCart(Cart Cart, int id)
        {
            var CartCurrent = _context.Carts.Where(s => s.Id == id)
                                                         .FirstOrDefault();
            if (CartCurrent != null)
            {
                CartModel CartModel = _CartMapper.Map<Cart, CartModel>(Cart);
                _DAL.UpdateCart(Cart, CartCurrent);
                return CartModel;
            }
            else
            {
                throw new Exception("Invalid ID");
            }
        }

    }
}
