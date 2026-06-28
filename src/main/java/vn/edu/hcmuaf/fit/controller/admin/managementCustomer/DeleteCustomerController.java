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

            int result = iCustomerService.deleteUser(idUser); // Gọi hàm xóa bạn vừa tạo

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=Đã xóa khách hàng thành công!&alert=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=Lỗi: Không xóa được khách hàng!&alert=danger");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=Lỗi hệ thống!&alert=danger");
        }
    }
}