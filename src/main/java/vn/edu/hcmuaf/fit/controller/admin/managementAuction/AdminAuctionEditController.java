package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;

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
            response.sendRedirect(request.getContextPath() +
                "/admin-auction-list?message=Không tìm thấy phiên đấu giá!&alert=danger");
            return;
        }

        // Chỉ cho phép sửa phiên đang WAITING
        if (!"WAITING".equals(auction.getStatus())) {
            response.sendRedirect(request.getContextPath() +
                "/admin-auction-list?message=Chỉ được sửa phiên chưa bắt đầu (WAITING)!&alert=warning");
            return;
        }

        request.setAttribute("title", "Quản Lý Đấu Giá");
        request.setAttribute("auction", auction);

        request.getRequestDispatcher("views/admin/auction-edit.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        if ("delete".equals(action)) {
            // ===== XÓA phiên =====
            int result = auctionService.deleteAuction(id);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() +
                    "/admin-auction-list?message=Xóa phiên đấu giá thành công!&alert=success");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/admin-auction-list?message=Không thể xóa! Phiên đã bắt đầu hoặc không tồn tại.&alert=danger");
            }

        } else if ("update".equals(action)) {
            // ===== CẬP NHẬT phiên =====
            try {
                double startPrice   = Double.parseDouble(request.getParameter("startPrice"));
                double minIncrement = Double.parseDouble(request.getParameter("minIncrement"));
                String startTimeStr = request.getParameter("startTime");
                String endTimeStr   = request.getParameter("endTime");

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                Timestamp startTime = new Timestamp(sdf.parse(startTimeStr).getTime());
                Timestamp endTime   = new Timestamp(sdf.parse(endTimeStr).getTime());

                if (!endTime.after(startTime)) {
                    response.sendRedirect(request.getContextPath() +
                        "/admin-auction-edit?id=" + id +
                        "&message=Thời gian kết thúc phải sau thời gian bắt đầu!&alert=danger");
                    return;
                }

                int result = auctionService.updateAuction(id, startPrice, minIncrement, startTime, endTime);
                if (result > 0) {
                    response.sendRedirect(request.getContextPath() +
                        "/admin-auction-list?message=Cập nhật phiên đấu giá thành công!&alert=success");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/admin-auction-list?message=Cập nhật thất bại! Phiên không còn ở trạng thái WAITING.&alert=danger");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() +
                    "/admin-auction-list?message=Lỗi: " + e.getMessage() + "&alert=danger");
            }
        }
    }
}
