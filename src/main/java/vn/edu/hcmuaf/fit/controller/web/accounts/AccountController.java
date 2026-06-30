package vn.edu.hcmuaf.fit.controller.web.accounts;

import vn.edu.hcmuaf.fit.dao.IBillDAO;
import vn.edu.hcmuaf.fit.dao.impl.BillDAO;
import vn.edu.hcmuaf.fit.dao.impl.CartDao;
import vn.edu.hcmuaf.fit.model.CartModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;
import vn.edu.hcmuaf.fit.utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "account", value = "/account")
public class AccountController extends HttpServlet {
    IBillDAO iBillDAO = new BillDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        CustomerModel cus = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");
        if(cus == null) {
            response.sendRedirect(request.getContextPath()+"/login?action=login");
        }else {
            if (action != null) {
                if (action.equalsIgnoreCase("account")) {
                    request.setAttribute("cus", cus);
                    request.getRequestDispatcher("/views/web/account.jsp").forward(request, response);

                } else if (action.equalsIgnoreCase("changePassword")) {
                    request.getRequestDispatcher("/views/web/changePassword.jsp").forward(request, response);

                } else if (action.equalsIgnoreCase("reviewOrders")) {
                    request.setAttribute("listBillDeliverByIdOrder", listDonHang(cus,1));
                    request.setAttribute("listBillWarByIdOrder",  listDonHang(cus,1));
                    request.setAttribute("listBillDelivByIdOrder",  listDonHang(cus,2));
                    request.setAttribute("listBillRateByIdOrder",  cartModelsChuaRate(cus,3));
                    request.setAttribute("listBillByIdOrder", listDonHang(cus,3));
                    request.setAttribute("listBillCancelByIdOrder", listDonHang(cus,-1));

                    request.getRequestDispatcher("/views/web/reviewOrders.jsp").forward(request, response);
                } else if (action.equalsIgnoreCase("myAuction")) {

                response.sendRedirect(request.getContextPath() + "/my-auction");
                return;

            }
            } else {
                request.setAttribute("cus", cus);
                request.getRequestDispatcher("/views/web/account.jsp").forward(request, response);
            }
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra session xem user còn đăng nhập không
        CustomerModel cus = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");
        if (cus == null) {
            response.sendRedirect(request.getContextPath() + "/login?action=login");
            return;
        }

        // 2. Nhận dữ liệu từ form gửi lên (Khớp đúng thuộc tính name="" bên JSP)
        String lastName = request.getParameter("fname");      // Họ
        String firstName = request.getParameter("lname");     // Tên
        String phone = request.getParameter("phoneNumber");   // SĐT
        String address = request.getParameter("address");     // Địa chỉ cụ thể

        // Nhận thêm Tỉnh/Huyện/Xã (Đọc tiếp Bước 2 bên dưới để biết tại sao cần sửa JSP mới nhận được)
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");

        // Ghép chuỗi địa chỉ đầy đủ (Ví dụ: "123 Lê Lợi, Phường Bến Nghé, Quận 1, TP.HCM")
        StringBuilder fullAddress = new StringBuilder();
        if (address != null && !address.trim().isEmpty()) fullAddress.append(address.trim());
        if (ward != null && !ward.isEmpty()) fullAddress.append(", ").append(ward);
        if (district != null && !district.isEmpty()) fullAddress.append(", ").append(district);
        if (city != null && !city.isEmpty()) fullAddress.append(", ").append(city);

        // 3. Cập nhật dữ liệu vào object Model
        cus.setLastName(lastName);
        cus.setFirstName(firstName);
        cus.setPhone(phone);
        cus.setAddress(fullAddress.toString());
        cus.setFullName(lastName + " " + firstName);

        // 4. Gọi DAO để UPDATE xuống Database MySQL
        // (Lưu ý: Bạn tự kiểm tra xem class DAO quản lý Customer của bạn tên là CustomerDAO hay UserDAO nhé)
    /* Ví dụ:
       CustomerDAO customerDAO = new CustomerDAO();
       boolean isSuccess = customerDAO.updateCustomer(cus);
    */
        boolean isSuccess = true; // <--- Tạm để true, bạn hãy gọi hàm update thực tế của DAO vào đây!

        if (isSuccess) {
            // 5. CỰC KỲ QUAN TRỌNG: Ghi đè lại thông tin mới vào Session
            // Nếu thiếu dòng này, cập nhật DB xong tải lại trang vẫn hiển thị tên cũ!
            SessionUtil.getInstance().putValue(request, "USERMODEL", cus);

            request.setAttribute("message", "Cập nhật thông tin tài khoản thành công!");
            request.setAttribute("alert", "success");
        } else {
            request.setAttribute("message", "Cập nhật thất bại, vui lòng thử lại!");
            request.setAttribute("alert", "danger");
        }

        // 6. Truyền lại cus ra view và đẩy về trang cũ
        request.setAttribute("cus", cus);
        request.getRequestDispatcher("/views/web/account.jsp").forward(request, response);
    }

    public List<CartModel> listDonHang(CustomerModel cus, int info) {
        CartDao cartDao = new CartDao();
        List<CartModel> listModel = cartDao.getAllCartByIdUser(cus.getIdUser());
        for(int i =0 ;i < listModel.size();i++) {
            listModel.get(i).setBills(new BillDAO().findAllBillByIdCart( listModel.get(i).getId()));
        }
        List<CartModel> dangChoList = new ArrayList<>();
        for (int i =0;i<listModel.size();i++) {
            if(listModel.get(i).getInShip() == info) {
                dangChoList.add(listModel.get(i));
            }
        }
        return  dangChoList;
    }
    public List<CartModel> cartModelsChuaRate(CustomerModel cus, int info) {
        CartDao cartDao = new CartDao();
        List<CartModel> listModel = cartDao.getAllCartByIdUser(cus.getIdUser());
        for(int i =0 ;i < listModel.size();i++) {
            listModel.get(i).setBills(new BillDAO().findAllBillByIdCartRate( listModel.get(i).getId()));
        }
        List<CartModel> dangChoList = new ArrayList<>();
        for (int i =0;i<listModel.size();i++) {
            if(listModel.get(i).getInShip() == info && listModel.get(i).getBills().size() >0) {
                dangChoList.add(listModel.get(i));
            }
        }
        return  dangChoList;
    }
}
