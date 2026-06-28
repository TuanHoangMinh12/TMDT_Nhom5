package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý trang CHI TIẾT phiên đấu giá.
 * URL: /admin-auction-detail
 *
 * GET  ?id=X          -> Hiển thị chi tiết + lịch sử bid của phiên
 * POST ?action=finalize  -> Chốt phiên (tìm người thắng, gửi thông báo)
 * POST ?action=markPaid  -> Chuyển trạng thái FINISHED -> PAID
 * POST ?action=lockUser  -> Khóa tài khoản người dùng spam
 * POST ?action=unlockUser-> Mở khóa tài khoản
 */
@WebServlet(name = "admin-auction-detail", value = "/admin-auction-detail")
public class AdminAuctionDetailController extends HttpServlet {

    private AuctionDAO auctionDAO = new AuctionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        // Sync trạng thái trước khi hiển thị
        auctionDAO.syncAuctionStatus();

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin-auction-list");
            return;
        }

        int id = Integer.parseInt(idStr);

        // Lấy thông tin phiên đấu giá
        AuctionModel auction = auctionDAO.findById(id);
        if (auction == null) {
            response.sendRedirect(request.getContextPath() +
                "/admin-auction-list?message=Không tìm thấy phiên!&alert=danger");
            return;
        }

        // Lấy danh sách lịch sử bid của phiên này
        List<AuctionBidModel> bidHistory = auctionDAO.getBidsByAuctionId(id);

        // Nhận message từ redirect
        String message = request.getParameter("message");
        String alert   = request.getParameter("alert");
        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("alert", alert);
        }

        request.setAttribute("title",      "Quản Lý Đấu Giá");
        request.setAttribute("auction",    auction);
        request.setAttribute("bidHistory", bidHistory);

        request.getRequestDispatcher("views/admin/auction-detail.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        String action  = request.getParameter("action");
        int auctionId  = Integer.parseInt(request.getParameter("auctionId"));
        String redirect = request.getContextPath() + "/admin-auction-detail?id=" + auctionId;

        switch (action) {

            case "finalize":
                // ===== CHỐT PHIÊN =====
                // Chỉ chốt được phiên đã FINISHED
                AuctionModel auction = auctionDAO.findById(auctionId);
                if (auction == null || !"FINISHED".equals(auction.getStatus())) {
                    response.sendRedirect(redirect +
                        "&message=Chỉ chốt được phiên đã kết thúc!&alert=warning");
                    return;
                }
                // Tìm người thắng và cập nhật DB
                boolean ok = auctionDAO.finalizeAuction(auctionId);
                if (ok) {
                    // Lấy lại thông tin auction sau khi chốt (để có winner_id, current_price)
                    AuctionModel updated = auctionDAO.findById(auctionId);
                    if (updated != null && updated.getWinnerId() != null) {
                        // Gửi thông báo cho tất cả người tham gia
                        auctionDAO.sendNotificationsAfterFinalize(
                            auctionId,
                            updated.getWinnerId(),
                            updated.getBookName(),
                            updated.getCurrentPrice()
                        );
                    }
                    response.sendRedirect(redirect +
                        "&message=Chốt phiên thành công! Thông báo đã được gửi đến người tham gia.&alert=success");
                } else {
                    response.sendRedirect(redirect +
                        "&message=Chốt phiên thất bại!&alert=danger");
                }
                break;

            case "markPaid":
                // ===== ĐÁNH DẤU ĐÃ THANH TOÁN (FINISHED -> PAID) =====
                int r = auctionDAO.updateStatus(auctionId, "PAID");
                if (r > 0) {
                    response.sendRedirect(redirect +
                        "&message=Đã cập nhật trạng thái PAID thành công!&alert=success");
                } else {
                    response.sendRedirect(redirect +
                        "&message=Cập nhật thất bại!&alert=danger");
                }
                break;

            case "lockUser":
                // ===== KHÓA TÀI KHOẢN =====
                int userId = Integer.parseInt(request.getParameter("userId"));
                int lockResult = auctionDAO.lockUser(userId);
                if (lockResult > 0) {
                    response.sendRedirect(redirect +
                        "&message=Đã khóa tài khoản người dùng #" + userId + "!&alert=success");
                } else {
                    response.sendRedirect(redirect +
                        "&message=Khóa tài khoản thất bại!&alert=danger");
                }
                break;

            case "unlockUser":
                // ===== MỞ KHÓA TÀI KHOẢN =====
                int unlockId = Integer.parseInt(request.getParameter("userId"));
                int unlockResult = auctionDAO.unlockUser(unlockId);
                if (unlockResult > 0) {
                    response.sendRedirect(redirect +
                        "&message=Đã mở khóa tài khoản người dùng #" + unlockId + "!&alert=success");
                } else {
                    response.sendRedirect(redirect +
                        "&message=Mở khóa thất bại!&alert=danger");
                }
                break;

            default:
                response.sendRedirect(redirect);
        }
    }
}
