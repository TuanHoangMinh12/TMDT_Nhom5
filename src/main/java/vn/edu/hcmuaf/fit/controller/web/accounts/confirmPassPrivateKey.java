//package vn.edu.hcmuaf.fit.controller.web.accounts;
//
//import vn.edu.hcmuaf.fit.dao.impl.CustomerDAO;
//import vn.edu.hcmuaf.fit.utils.EmailUtil;
//import vn.edu.hcmuaf.fit.utils.MD5Utils;
//import vn.edu.hcmuaf.fit.utils.SessionUtil;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.net.InetAddress;
//import java.security.*;
//import java.security.spec.PKCS8EncodedKeySpec;
//import java.security.spec.X509EncodedKeySpec;
//import java.util.Base64;
//
//@WebServlet(name = "confirmPassKey", value = "/confirmPassKey")
//public class confirmPassPrivateKey extends HttpServlet {
//    private static KeyPair keypair;
//    private static PublicKey publicKey_khoa;
//    private static PrivateKey privateKey_khoa;
//    static String publicKeyStr;
//    static String privateKeyStr;
//    public static String keyToString(PrivateKey privateKey) {
//        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(privateKey.getEncoded());
//        return Base64.getEncoder().encodeToString(keySpec.getEncoded());
//    }
//
//    public static String keyToString(PublicKey publicKey) {
//        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKey.getEncoded());
//        return Base64.getEncoder().encodeToString(keySpec.getEncoded());
//    }
//
//    public static void create_key(){
//        // create key
//        KeyPairGenerator keyGenerator = null;
//        try {
//            keyGenerator = KeyPairGenerator.getInstance("RSA");
//            keyGenerator.initialize(2048);
//            keypair = keyGenerator.generateKeyPair();
//
//            publicKey_khoa = keypair.getPublic();
//            privateKey_khoa = keypair.getPrivate();
//            // Convert the keys to string format
//            privateKeyStr = keyToString(privateKey_khoa);
//            publicKeyStr  = keyToString(publicKey_khoa);
//        } catch (NoSuchAlgorithmException e) {
//            throw new RuntimeException(e);
//        }
//    }
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        request.getRequestDispatcher("/views/web/account.jsp").forward(request, response);
//    }
//
//    // luu private key ve may tinh
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html; charset=UTF-8");
//        InetAddress myIP=InetAddress.getLocalHost();
//        String ip= myIP.getHostAddress();
//        CustomerDAO dao = new CustomerDAO();
//        EmailUtil email = new EmailUtil();
//        create_key();
//        String password = MD5Utils.encrypt(request.getParameter("password"));
//        String PASSWORD_USER = (String) SessionUtil.getInstance().getValue(request, "PASSWORD_USER");
//        String toMail = (String) SessionUtil.getInstance().getValue(request, "MAIL");
//        int id_user = (int) SessionUtil.getInstance().getValue(request, "ID_USER");
//
//        if(password.substring(3).equals(PASSWORD_USER.substring(3))){
//            dao.update_publicKey(id_user);
//            dao.insert_publicKey(id_user,publicKeyStr);
//
//            // luu private key ve may
//            PrintWriter pw = new PrintWriter("C:\\Users\\ADMIN\\Downloads\\new_privateKey.txt", "UTF-8");
//            pw.println(privateKeyStr);
//            pw.flush();
//            pw.close();
//
//            request.setAttribute("message", "Đã lưu private key mới về máy của bạn");
//            request.setAttribute("alert", "success");
//            request.getRequestDispatcher("/views/web/confirmPassPrivateKey.jsp").forward(request,response );
//        }else{
//            request.setAttribute("message", "Mật khẩu không chính xác");
//            request.setAttribute("alert", "danger");
//            request.getRequestDispatcher("/views/web/confirmPassPrivateKey.jsp").forward(request, response);
//        }
//    }
//
//    // gui ve email
////    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
////            throws ServletException, IOException {
////        response.setContentType("text/html; charset=UTF-8");
////        InetAddress myIP=InetAddress.getLocalHost();
////        String ip= myIP.getHostAddress();
////        CustomerDAO dao = new CustomerDAO();
////        EmailUtil email = new EmailUtil();
////        create_key();
////        String password = MD5Utils.encrypt(request.getParameter("password"));
////        String PASSWORD_USER = (String) SessionUtil.getInstance().getValue(request, "PASSWORD_USER");
////        String toMail = (String) SessionUtil.getInstance().getValue(request, "MAIL");
////        int id_user = (int) SessionUtil.getInstance().getValue(request, "ID_USER");
////
////        if(password.substring(3).equals(PASSWORD_USER.substring(3))){
////            dao.update_publicKey(id_user);
////            dao.insert_publicKey(id_user,publicKeyStr);
////            email.sendNewEmail(toMail, privateKeyStr);
////            request.setAttribute("message", "Đã gửi private key mới về email của bạn");
////            request.setAttribute("alert", "success");
////            request.getRequestDispatcher("/views/web/confirmPassPrivateKey.jsp").forward(request,response );
////        }else{
////            request.setAttribute("message", "Mật khẩu không chính xác");
////            request.setAttribute("alert", "danger");
////            request.getRequestDispatcher("/views/web/confirmPassPrivateKey.jsp").forward(request, response);
////        }
////    }
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        processRequest(request,response);
//
//    }
//}
