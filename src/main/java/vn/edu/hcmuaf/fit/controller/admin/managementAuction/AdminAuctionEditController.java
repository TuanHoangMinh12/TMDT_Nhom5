package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Servlet xử lý SỬA và XÓA phiên đấu giá.
 *
 * GET  ?id=X           -> Hiển thị form sửa (điền sẵn dữ liệu hiện tại)
 * POST ?action=update  -> Cập nhật phiên
 * POST ?action=delete  -> Xóa phiên (chỉ được khi status=WAITING)
 */
@WebServlet(name = "admin-auction-edit", value = "/admin-auction-edit")
public class AdminAuctionEditController extends HttpServlet {

    @Inject
    IAuctionService auctionService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin-auction-list");
            return;
        }

        int id = Integer.parseInt(idStr);
        AuctionModel auction = auctionService.findById2(id);

        if (auction == null) {
            new MessageParameterUntil("Không tìm thấy phiên đấu giá!", "danger",
                    "views/admin/auction-list.jsp", request, response).send();
            return;
        }

        // Chỉ cho phép sửa phiên đang WAITING
        if (!"WAITING".equals(auction.getStatus())) {
            new MessageParameterUntil("Chỉ được sửa phiên chưa bắt đầu (WAITING)!", "danger",
                    "views/admin/auction-list.jsp", request, response).send();
            return;
        }

        request.setAttribute("title", "Quản Lý Đấu Giá");
        request.setAttribute("auction", auction);


        request.getRequestDispatcher("views/admin/auction-edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        if ("delete".equals(action)) {
            // Xóa phiên
            int result = auctionService.deleteAuction(id);
            if (result > 0) {
                request.getSession().setAttribute("message", "Đã xóa phiên thành công!");
                request.getSession().setAttribute("alert", "success");
                response.sendRedirect(request.getContextPath() + "/admin-auction-list");
            } else {
                new MessageParameterUntil("Xóa thất bại!", "danger", "views/admin/auction-list.jsp", request, response).send();
            }

        } else if ("update".equals(action)) {
            // ===== CẬP NHẬT phiên =====
            try {
                double startPrice   = Double.parseDouble(request.getParameter("startPrice"));
                double minIncrement = Double.parseDouble(request.getParameter("minIncrement"));
                String startTimeStr = request.getParameter("startTime");
                String endTimeStr   = request.getParameter("endTime");

                // 1. Kiểm tra giá trị âm hoặc bằng 0
                if (startPrice <= 0 || minIncrement <= 0) {
                    request.getSession().setAttribute("message", "Giá khởi điểm và bước giá phải lớn hơn 0!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" + id);
                    return;
                }

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Timestamp startTime = new Timestamp(sdf.parse(startTimeStr).getTime());
                Timestamp endTime   = new Timestamp(sdf.parse(endTimeStr).getTime());

                // 2. Kiểm tra thời gian
                if (!endTime.after(startTime)) {
                    request.getSession().setAttribute("message", "Thời gian kết thúc phải sau thời gian bắt đầu!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" + id);
                    return;
                }

                // 3. Kiểm tra logic thêm: Thời gian bắt đầu không được là quá khứ
                if (startTime.before(new Timestamp(System.currentTimeMillis()))) {
                    request.getSession().setAttribute("message", "Thời gian bắt đầu không thể là thời điểm trong quá khứ!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" + id);
                    return;
                }

                int result = auctionService.updateAuction(id, startPrice, minIncrement, startTime, endTime);
                if (result > 0) {
                    // THÀNH CÔNG: Dùng Redirect kết hợp Session (Flash Message)
                    request.getSession().setAttribute("message", "Cập nhật phiên thành công!");
                    request.getSession().setAttribute("alert", "success");
                    response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id="+id);
                } else {
//                    new MessageParameterUntil("Cập nhật thất bại!",
//                            "danger", null, request, response)
//                            .sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" + id);
                    request.getSession().setAttribute("message", "Cập nhật thất bại!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" +id);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Cập nhật thất bại!");
                request.getSession().setAttribute("alert", "danger");
                response.sendRedirect(request.getContextPath() + "/admin-auction-edit?id=" + id);
            }
        }
    }
}
