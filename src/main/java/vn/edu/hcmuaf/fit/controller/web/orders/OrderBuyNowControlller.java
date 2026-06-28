package vn.edu.hcmuaf.fit.controller.web.orders;

import vn.edu.hcmuaf.fit.dao.IProductDAO;
import vn.edu.hcmuaf.fit.dao.impl.CartDao;
import vn.edu.hcmuaf.fit.dao.impl.ProductDAO;
import vn.edu.hcmuaf.fit.model.CartModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "orderBuyNowController", value = "/orderBuyNowController")
public class OrderBuyNowControlller extends HttpServlet {
    private final IProductDAO productDAO = new ProductDAO();
    private final CartDao cartDao = new CartDao();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("product_id");
        if (productId != null) {
            Product product = productDAO.getProductById(Integer.parseInt(productId));

            if (product == null || product.getIdBook() == 0) {
                response.sendRedirect(request.getContextPath() + "/products/product-detail?id=" + productId + "&error=not_found");
                return;
            }

            int remainQuantity = productDAO.getRemainQuantity(product.getIdBook());

            // 1. ĐỒNG BỘ KEY: Kiểm tra xem khách đã đăng nhập chưa để gọi đúng tên Key Giỏ hàng
            CustomerModel customer = (CustomerModel) request.getSession().getAttribute("USERMODEL");
            String cartKey = (customer != null) ? ("cart_" + customer.getIdUser()) : "cart";

            // 2. Lấy đúng giỏ hàng đó ra, không được new bừa bãi làm mất hàng cũ của khách
            CartModel cart = (CartModel) request.getSession().getAttribute(cartKey);
            if (cart == null) {
                cart = new CartModel();
                cart.setId(cartDao.setID());
            }

            String quantity = request.getParameter("quantity");
            int qnt = quantity == null ? 1 : Integer.parseInt(quantity);

            // Nhét sản phẩm mua ngay vào giỏ
            cart.addProduct(product, qnt);

            // 3. Cập nhật lại Session đúng tên Key đã quy định
            request.getSession().setAttribute(cartKey, cart);

            // 4. CHỐT CHẶN DB: Nếu khách đã đăng nhập, lưu luôn xuống DB ngay giây phút này
            if (customer != null) {
                cartDao.saveCart(customer.getIdUser(), cart);
            }

            response.sendRedirect(request.getContextPath() + "/cart?buynow=true&product_id=" + productId);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
