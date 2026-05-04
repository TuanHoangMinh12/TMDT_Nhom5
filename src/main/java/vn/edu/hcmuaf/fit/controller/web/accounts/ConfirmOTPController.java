package vn.edu.hcmuaf.fit.controller.web.accounts;

import vn.edu.hcmuaf.fit.dao.impl.CustomerDAO;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.utils.EmailUtil;
import vn.edu.hcmuaf.fit.utils.MD5Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.InetAddress;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@WebServlet(name = "confirmOTP", value = "/confirmOTP")
public class ConfirmOTPController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/web/signup.jsp").forward(request, response);
    }


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        InetAddress myIP=InetAddress.getLocalHost();
        String ip= myIP.getHostAddress();
        String code = request.getParameter("code");
        HttpSession session = request.getSession();
        CustomerModel user = (CustomerModel) session.getAttribute("registerUser");
        String public_key = (String) session.getAttribute("public_key");
        String private_key = (String) session.getAttribute("private_key");
        String toEmail = (String) session.getAttribute("toEmail");
        ExecutorService executorService = Executors.newFixedThreadPool(10); // Số luồng tối đa
        CustomerDAO dao = new CustomerDAO();
        //String idUser = request.getParameter("id_user");
        if(code.equals(user.getCode()) && (System.currentTimeMillis() / 1000/60) - user.getTime_active_code() <= 5){
            dao.signup(user.getEmail(), MD5Utils.encrypt( user.getPassword()), user.getFirstName(),user.getLastName(), user.getPhone(), user.getAddress());
            dao.insert_publicKey(dao.take_id(), public_key);
            EmailUtil sm = new EmailUtil();
            executorService.submit(() -> {
                // Gửi email ở đây
                sm.sendEmail(toEmail, private_key);
            });

            session.removeAttribute("registerUser");
            request.getRequestDispatcher("/views/login.jsp").forward(request,response );
        }else{
            request.setAttribute("message", "Incorrect verification code");
            request.setAttribute("alert", "danger");
            request.getRequestDispatcher("/views/web/confirmRegister.jsp").forward(request, response);

        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request,response);

    }
}
