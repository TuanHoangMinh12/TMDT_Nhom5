package vn.edu.hcmuaf.fit.controller.web.key;

import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.services.IOrderService;
import vn.edu.hcmuaf.fit.services.impl.OrderService;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;
import vn.edu.hcmuaf.fit.utils.RSAUtil;
import vn.edu.hcmuaf.fit.utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "privateKey", value = "/privateKey")
public class PrivateKeyController extends HttpServlet {
    IOrderService orderService = new OrderService();
    String listId;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CustomerModel cus = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");
        if(cus == null) {
            response.sendRedirect(request.getContextPath()+"/login?action=login");
        }else{
            listId =  request.getParameter("list_id");

            if(listId.equals("")){
                new MessageParameterUntil("Chưa chọn sản phẩm", "warning", "/views/web/cart.jsp", request, response).send();
            }else if(orderService.checkIdExistsInCart(listId, request, response)) {
                new MessageParameterUntil("Sản phẩm không tồn tại", "warning", "/views/web/cart.jsp", request, response).send();
            }else{
                request.getRequestDispatcher("/views/web/formPrivateKey.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String privateKey = request.getParameter("privateKey").trim();
        RSAUtil rsa = new RSAUtil();
        try {
            rsa.setPrivateKey(privateKey);
//            rsa.encrypt("Test");
            request.getSession().setAttribute("PRIVATE_KEY", privateKey);
            response.sendRedirect(request.getContextPath()+"/orderAddVoucher?list_id="+listId);
        } catch (Exception e) {
            request.getSession().setAttribute("PRIVATE_KEY", privateKey);
            response.sendRedirect(request.getContextPath()+"/orderAddVoucher?list_id="+listId);
//            new MessageParameterUntil("Private key không hợp lệ!", "danger", "/views/web/cart.jsp", request, response).send();
        }

    }
}
