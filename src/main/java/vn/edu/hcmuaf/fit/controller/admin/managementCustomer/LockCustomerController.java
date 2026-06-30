package vn.edu.hcmuaf.fit.controller.admin.managementCustomer;

import vn.edu.hcmuaf.fit.bean.Log;
import vn.edu.hcmuaf.fit.dao.impl.CustomerDAO;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.services.ICustomerService;
import vn.edu.hcmuaf.fit.utils.SessionUtil;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.InetAddress;

/**
 * Servlet xử lý KHÓA / MỞ KHÓA tài khoản người dùng.
 * URL: /lock-customer
 *
 * Nhận POST từ form ẩn trong table-data-customer.jsp với 2 param:
 *   idUser = ID người dùng
 *   action = "lock" | "unlock"
 *
 * Status trong DB:
 *   1 = Hoạt động bình thường
 *   2 = Bị khóa (CustomerDAO đã dùng status=2)
 */
@WebServlet(name = "lock-customer", value = "/lock-customer")
public class LockCustomerController extends HttpServlet {

    @Inject
    ICustomerService iCustomerService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        CustomerModel adminUser = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");
        int idUser = Integer.parseInt(request.getParameter("idUser"));
        String action = request.getParameter("action"); // Nhận "lock" hoặc "unlock"

        try {
            InetAddress myIP = InetAddress.getLocalHost();
            String ip = myIP.getHostAddress();

            int result = 0;
            String successMsg = "";
            String errorMsg = "";

            // Chỉ xử lý 1 action dựa trên tham số truyền vào
            if ("lock".equals(action)) {
                result = iCustomerService.lockUser(idUser);
                successMsg = "Đã khóa tài khoản thành công!";
                errorMsg = "Khóa tài khoản thất bại!";
            } else if ("unlock".equals(action)) {
                result = iCustomerService.unlockUser(idUser);
                successMsg = "Đã mở khóa tài khoản thành công!";
                errorMsg = "Mở khóa tài khoản thất bại!";
            }

            if (result >= 1) {
                if (adminUser != null) {
                    Log log = new Log(Log.WARNING, ip, "Admin thực hiện: " + action + " tài khoản",
                            adminUser.getIdUser(), "Tài khoản bị tác động: " + idUser, 1);
                    log.insert();
                }
                request.getSession().setAttribute("message", successMsg);
                request.getSession().setAttribute("alert", "success");
            } else {
                request.getSession().setAttribute("message", errorMsg);
                request.getSession().setAttribute("alert", "danger");
            }

            response.sendRedirect(request.getContextPath() + "/admin-table-customer");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Có lỗi xảy ra!");
            request.getSession().setAttribute("alert", "danger");
            response.sendRedirect(request.getContextPath() + "/admin-table-customer");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin-table-customer");
    }
}
