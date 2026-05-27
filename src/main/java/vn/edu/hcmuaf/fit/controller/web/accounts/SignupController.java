package vn.edu.hcmuaf.fit.controller.web.accounts;

import vn.edu.hcmuaf.fit.dao.impl.CustomerDAO;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.utils.EmailUtil;
import vn.edu.hcmuaf.fit.utils.MD5Utils;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
// import java.io.PrintWriter;

// import java.security.*;
// import java.security.spec.PKCS8EncodedKeySpec;
// import java.security.spec.X509EncodedKeySpec;

// import java.util.Base64;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@WebServlet(name = "signup", value = "/signup")
public class SignupController extends HttpServlet {

    // ===== RSA / PRIVATE KEY (ĐÃ TẮT) =====

//    private static KeyPair keypair;
//    private static PublicKey publicKey_khoa;
//    private static PrivateKey privateKey_khoa;
//
//    String publicKeyStr;
//    String privateKeyStr;

//    public static String keyToString(PrivateKey privateKey) {
//        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(privateKey.getEncoded());
//        return Base64.getEncoder().encodeToString(keySpec.getEncoded());
//    }

//    public String keyToString(PublicKey publicKey) {
//        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKey.getEncoded());
//        return Base64.getEncoder().encodeToString(keySpec.getEncoded());
//    }

//    public void create_key() {
//        try {
//            KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance("RSA");
//            keyGenerator.initialize(2048);
//
//            keypair = keyGenerator.generateKeyPair();
//
//            publicKey_khoa = keypair.getPublic();
//            privateKey_khoa = keypair.getPrivate();
//
//            privateKeyStr = keyToString(privateKey_khoa);
//            publicKeyStr = keyToString(publicKey_khoa);
//
//            System.out.println(privateKeyStr);
//
//        } catch (NoSuchAlgorithmException e) {
//            throw new RuntimeException(e);
//        }
//    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/web/signup.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String re_pass = request.getParameter("password2");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String phone = request.getParameter("phoneNumber");
        String address = request.getParameter("address");

        ExecutorService executorService = Executors.newFixedThreadPool(10);

        // create_key();

        if (!email.equals("") &&
                !pass.equals("") &&
                !re_pass.equals("") &&
                !fname.equals("") &&
                !lname.equals("")) {

            if (!pass.equals(re_pass)) {

                response.sendRedirect(request.getContextPath() + "/login");

            } else {

                CustomerDAO customerDAO = new CustomerDAO();
                CustomerModel account = customerDAO.checkAccountExist(email);

                if (account == null) {

                    EmailUtil sm = new EmailUtil();
                    String code = sm.getRandom();

                    CustomerModel user = new CustomerModel(
                            email,
                            pass,
                            fname,
                            lname,
                            phone,
                            address,
                            code,
                            System.currentTimeMillis() / 1000 / 60
                    );

                    customerDAO.signup(
                            user.getEmail(),
                            MD5Utils.encrypt(user.getPassword()),
                            user.getFirstName(),
                            user.getLastName(),
                            user.getPhone(),
                            user.getAddress()
                    );

                    // ===== RSA / PRIVATE KEY (ĐÃ TẮT) =====

                    // customerDAO.insert_publicKey(customerDAO.take_id(), publicKeyStr);

                    // PrintWriter pw = new PrintWriter(
                    //         "C:\\Users\\ADMIN\\Downloads\\privateKey.txt",
                    //         "UTF-8"
                    // );
                    //
                    // pw.println(privateKeyStr);
                    // pw.flush();
                    // pw.close();

                    request.getRequestDispatcher("/views/login.jsp")
                            .forward(request, response);

                } else {

                    if (customerDAO.getTypeLogin(account.getEmail()) == 2) {

                        new MessageParameterUntil(
                                "Tài khoản này của bạn đã được đăng nhập bằng tài khoản google",
                                "danger",
                                "/views/web/confirmRegister.jsp",
                                request,
                                response
                        ).send();

                    } else {

                        new MessageParameterUntil(
                                "Email đã tồn tại",
                                "danger",
                                "/views/web/signup.jsp",
                                request,
                                response
                        ).send();
                    }
                }
            }

        } else {

            new MessageParameterUntil(
                    "Vui lòng nhập thông tin đầy đủ",
                    "danger",
                    "/views/web/signup.jsp",
                    request,
                    response
            ).send();
        }
    }

    // ===== VERIFY EMAIL VERSION (ĐÃ TẮT) =====

//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        response.setContentType("text/html; charset=UTF-8");
//        request.setCharacterEncoding("UTF-8");
//
//        String email = request.getParameter("email");
//        String pass = request.getParameter("password");
//        String re_pass = request.getParameter("password2");
//        String fname = request.getParameter("fname");
//        String lname = request.getParameter("lname");
//        String phone = request.getParameter("phoneNumber");
//        String address = request.getParameter("address");
//
//        ExecutorService executorService = Executors.newFixedThreadPool(10);
//
//        create_key();
//
//        if (!email.equals("") &&
//                !pass.equals("") &&
//                !re_pass.equals("") &&
//                !fname.equals("") &&
//                !lname.equals("")) {
//
//            if (!pass.equals(re_pass)) {
//
//                response.sendRedirect(request.getContextPath()+"/login");
//
//            } else {
//
//                CustomerDAO customerDAO = new CustomerDAO();
//                CustomerModel account = customerDAO.checkAccountExist(email);
//
//                if (account == null) {
//
//                    EmailUtil sm = new EmailUtil();
//                    String code = sm.getRandom();
//
//                    CustomerModel user = new CustomerModel(
//                            email,
//                            pass,
//                            fname,
//                            lname,
//                            phone,
//                            address,
//                            code,
//                            System.currentTimeMillis() / 1000 / 60
//                    );
//
//                    executorService.submit(() -> {
//                        sm.sendEmail(user);
//                    });
//
//                    HttpSession session = request.getSession();
//
//                    session.setAttribute("registerUser", user);
//                    session.setAttribute("public_key", publicKeyStr);
//                    session.setAttribute("private_key", privateKeyStr);
//                    session.setAttribute("toEmail", user.getEmail());
//
//                    new MessageParameterUntil(
//                            "Chúng tôi đã gửi mã xác minh đến email của bạn",
//                            "success",
//                            "/views/web/confirmRegister.jsp",
//                            request,
//                            response
//                    ).send();
//
//                } else {
//
//                    if (customerDAO.getTypeLogin(account.getEmail()) == 2) {
//
//                        new MessageParameterUntil(
//                                "Tài khoản này của bạn đã được đăng nhập bằng tài khoản google",
//                                "danger",
//                                "/views/web/confirmRegister.jsp",
//                                request,
//                                response
//                        ).send();
//
//                    } else {
//
//                        new MessageParameterUntil(
//                                "Email đã tồn tại",
//                                "danger",
//                                "/views/web/signup.jsp",
//                                request,
//                                response
//                        ).send();
//                    }
//                }
//            }
//
//        } else {
//
//            new MessageParameterUntil(
//                    "Vui lòng nhập thông tin đầy đủ",
//                    "danger",
//                    "/views/web/signup.jsp",
//                    request,
//                    response
//            ).send();
//        }
//    }

//    public static void main(String[] args) {
//        new SignupController().create_key();
//    }
}