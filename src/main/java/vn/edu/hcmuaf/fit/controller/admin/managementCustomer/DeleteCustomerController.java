package vn.edu.hcmuaf.fit.controller.admin.managementCustomer;

import vn.edu.hcmuaf.fit.services.ICustomerService;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "delete-customer", value = "/delete-customer")
public class DeleteCustomerController extends HttpServlet {

    @Inject
    ICustomerService iCustomerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idUser = Integer.parseInt(request.getParameter("idUser"));
            int result = iCustomerService.deleteUser(idUser);

            if (result > 0) {
                request.getSession().setAttribute("message", "Đã xóa khách hàng thành công!");
                request.getSession().setAttribute("alert", "success");
            } else {
                request.getSession().setAttribute("message", "Lỗi: Không xóa được khách hàng!");
                request.getSession().setAttribute("alert", "danger");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Lỗi hệ thống!");
            request.getSession().setAttribute("alert", "danger");
        }
        // Luôn redirect về trang danh sách
        response.sendRedirect(request.getContextPath() + "/admin-table-customer");
    }
}