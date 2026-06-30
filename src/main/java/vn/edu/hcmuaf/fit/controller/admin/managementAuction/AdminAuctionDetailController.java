package vn.edu.hcmuaf.fit.controller.admin.managementAuction;


import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.ICustomerService;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;


import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
/**
 * Servlet xử lý trang CHI TIẾT phiên đấu giá.
 * GET  ?id=X          -> Hiển thị chi tiết + lịch sử bid của phiên
 * POST ?action=finalize  -> Chốt phiên (tìm người thắng, gửi thông báo)
 * POST ?action=markPaid  -> Chuyển trạng thái FINISHED -> PAID
 * POST ?action=lockUser  -> Khóa tài khoản người dùng spam
 * POST ?action=unlockUser-> Mở khóa tài khoản
 */
@WebServlet(name = "admin-auction-detail", value = "/admin-auction-detail")
public class AdminAuctionDetailController extends HttpServlet {
    @Inject
    IAuctionService auctionService;
    @Inject
    ICustomerService customerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        // Sync trạng thái trước khi hiển thị
        auctionService.syncAuctionStatus();

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin-auction-list");
            return;
        }

        int auctionId = Integer.parseInt(idStr);

        // Lấy thông tin phiên đấu giá
        AuctionModel auction = auctionService.findById2(auctionId);
        if (auction == null) {
            request.getSession().setAttribute("message", "Không tìm thấy phiên đấu giá!");
            request.getSession().setAttribute("alert", "danger");
            response.sendRedirect(request.getContextPath() + "/admin-auction-list");
            return;
        }

        // Lấy danh sách lịch sử bid của phiên này
        List<AuctionBidModel> bidHistory = auctionService.getBidsByAuctionId(auctionId);

        // Đếm số lần bid của từng user trong phiên này -> phát hiện spam
        Map<Integer, Integer> bidCountMap = new HashMap<>();
        for (AuctionBidModel bid : bidHistory) {
            int uid = bid.getUserId();
            if (!bidCountMap.containsKey(uid)) {
                bidCountMap.put(uid, auctionService.countBidByUserInAuction(uid, auctionId));
            }
        }

        // Ngưỡng cảnh báo spam (có thể chỉnh tùy ý)
        int spamThreshold = 5;

        // Nhận message từ redirect
        String message = request.getParameter("message");
        String alert   = request.getParameter("alert");
        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("alert", alert);

            request.getSession().removeAttribute("message");
            request.getSession().removeAttribute("alert");
        }

        request.setAttribute("title","Quản Lý Đấu Giá");
        request.setAttribute("auction",    auction);
        request.setAttribute("bidHistory", bidHistory);
        request.setAttribute("bidCountMap", bidCountMap);
        request.setAttribute("spamThreshold", spamThreshold);

        request.getRequestDispatcher("views/admin/qlyDauGia/auction-detail.jsp")
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
                AuctionModel auction = auctionService.findById2(auctionId);

                if (auction == null || !"FINISHED".equals(auction.getStatus())) {
                    new MessageParameterUntil("Chỉ chốt được phiên đã kết thúc!", "warning", null, request, response)
                            .sendRedirect(redirect);
                    return;
                }

                // Tìm người thắng và cập nhật DB
                boolean ok = auctionService.finalizeAndNotify(auctionId);
                if (ok) {
                    new MessageParameterUntil("Chốt phiên thành công!", "success", null, request, response)
                            .sendRedirect(redirect);
                } else {
                    new MessageParameterUntil("Chốt phiên thất bại!", "danger", null, request, response)
                            .sendRedirect(redirect);
                }
                break;

            case "markPaid":
                // ===== ĐÁNH DẤU ĐÃ THANH TOÁN (FINISHED -> PAID) =====
                int r = auctionService.updateStatus(auctionId, "PAID");
                if (r > 0) {
                    new MessageParameterUntil("Đã cập nhật trạng thái PAID thành công!", "success", null, request, response)
                            .sendRedirect(redirect);
                } else {
                    new MessageParameterUntil("Cập nhật thất bại!", "danger", null, request, response)
                            .sendRedirect(redirect);
                }
                break;

            case "lockUser":
                // ===== KHÓA TÀI KHOẢN =====
                int userId = Integer.parseInt(request.getParameter("userId"));
                int lockResult = customerService.lockUser(userId);
                if (lockResult > 0) {
//                    response.sendRedirect(redirect +
//                        "&message=Đã khóa tài khoản người dùng #" + userId + "!&alert=success");

                    request.getSession().setAttribute("message", "Đã khóa tài khoản ID người dùng " + userId);
                    request.getSession().setAttribute("alert", "success");
                    response.sendRedirect(redirect);
                } else {
//                    response.sendRedirect(redirect +
//                        "&message=Khóa tài khoản thất bại!&alert=danger");
//                    response.sendRedirect( redirect);
                    request.getSession().setAttribute("message", "Khóa tài khoản thất bại!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(redirect);

                }
                break;

            case "unlockUser":
                // ===== MỞ KHÓA TÀI KHOẢN =====
                int unlockId = Integer.parseInt(request.getParameter("userId"));
                int unlockResult = customerService.unlockUser(unlockId);
                if (unlockResult > 0) {
//                    response.sendRedirect(redirect +
//                        "&message=Đã mở khóa tài khoản người dùng #" + unlockId + "!&alert=success");
//                    response.sendRedirect(redirect);

                    request.getSession().setAttribute("message", "Đã mở khóa ID tài khoản người dùng" + unlockId);
                    request.getSession().setAttribute("alert", "success");
                    response.sendRedirect(redirect);

                } else {
//                    response.sendRedirect(redirect +
//                        "&message=Mở khóa thất bại!&alert=danger");
//                    response.sendRedirect( redirect);

                    request.getSession().setAttribute("message", "Mở khóa thất bại!");
                    request.getSession().setAttribute("alert", "danger");
                    response.sendRedirect(redirect);
                }
                break;

            default:
                response.sendRedirect(redirect);
        }
    }
}
