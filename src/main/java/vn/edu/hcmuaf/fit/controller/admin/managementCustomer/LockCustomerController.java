package vn.edu.hcmuaf.fit.controller.admin.managementCustomer;

import vn.edu.hcmuaf.fit.bean.Log;
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

        // Admin đang đăng nhập (để ghi Log)
        CustomerModel adminUser = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");

        int idUser = Integer.parseInt(request.getParameter("idUser"));
        String action = request.getParameter("action"); // "lock" hoặc "unlock"

        try {
            InetAddress myIP = InetAddress.getLocalHost();
            String ip   = myIP.getHostAddress();

            int result;
            String logMsg, successMsg, errorMsg;

            if ("lock".equals(action)) {
                result = iCustomerService.lockUser(idUser);   // -> status=2
                logMsg = "Khóa tài khoản người dùng ID: " + idUser;
                successMsg = "Đã khóa tài khoản thành công!";
                errorMsg = "Khóa tài khoản thất bại!";
            } else {
                result = iCustomerService.unlockUser(idUser); // -> status=1
                logMsg = "Mở khóa tài khoản người dùng ID: " + idUser;
                successMsg = "Đã mở khóa tài khoản thành công!";
                errorMsg = "Mở khóa tài khoản thất bại!";
            }

            if (result >= 1) {
                // Ghi log hành động admin (theo đúng pattern dự án)
                if (adminUser != null) {
                    Log log = new Log(Log.WARNING, ip, logMsg, adminUser.getIdUser(), "Tài khoản bị tác động: " + idUser, 1);
                    log.insert();
                }
                response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=" + successMsg + "&alert=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=" + errorMsg + "&alert=danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-table-customer?message=Có lỗi xảy ra!&alert=danger");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin-table-customer");
    }
}
