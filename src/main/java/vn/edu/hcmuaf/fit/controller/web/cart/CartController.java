package vn.edu.hcmuaf.fit.controller.web.cart;

import vn.edu.hcmuaf.fit.model.CartModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "cart", value = "/cart")
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        CustomerModel user = (CustomerModel) request.getSession().getAttribute("USERMODEL");

        if (user != null) {
            String cartKey = "cart_" + user.getIdUser();
            CartModel cart = (CartModel) request.getSession().getAttribute(cartKey);
            request.setAttribute("cart", cart);
        } else {
            // Khách vãng lai dùng key mặc định là "cart"
            CartModel cart = (CartModel) request.getSession().getAttribute("cart");
            request.setAttribute("cart", cart);
        }

        String buynow = request.getParameter("buynow");
        String productId = request.getParameter("product_id");
        if ("true".equals(buynow) && productId != null) {
            request.setAttribute("buynow", true);
            request.setAttribute("buynowProductId", productId);
        }

        request.getRequestDispatcher("/views/web/cart.jsp").forward(request, response);
    }
}