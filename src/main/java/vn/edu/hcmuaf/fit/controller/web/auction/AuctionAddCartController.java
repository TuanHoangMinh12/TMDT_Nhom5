package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.model.*;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/auction-add-cart")
public class AuctionAddCartController extends HttpServlet {

    IAuctionService auctionService = new AuctionService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        CustomerModel user =
                (CustomerModel) request.getSession()
                        .getAttribute("USERMODEL");

        if(user==null){
            response.sendRedirect(
                    request.getContextPath()+"/login?action=login");
            return;
        }

        int auctionId =
                Integer.parseInt(request.getParameter("id"));

        AuctionModel auction =
                auctionService.getAuctionById(auctionId);

        if(auction==null){
            response.sendRedirect(request.getContextPath()+"/my-auction");
            return;
        }

        // Chỉ người thắng mới được thêm
        if(auction.getWinnerId()==null
                || auction.getWinnerId()!=user.getIdUser()){

            response.sendRedirect(request.getContextPath()+"/my-auction");
            return;
        }

        String cartKey = "cart_" + user.getIdUser();

        CartModel cart =
                (CartModel) request.getSession()
                        .getAttribute(cartKey);

        if(cart==null){
            cart = new CartModel();
        }

        Product product = auction.getProduct();

        product.setPrice(auction.getCurrentPrice());
        product.setPriceDiscount(auction.getCurrentPrice());

        product.setAuctionBook(true);
        if (!cart.getMap().containsKey(product.getIdBook())) {
            cart.addProduct(product, 1);
        }

        request.getSession().setAttribute(cartKey,cart);

        response.sendRedirect(request.getContextPath()+"/cart");
    }

}