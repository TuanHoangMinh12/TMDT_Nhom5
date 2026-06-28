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
import java.util.List;

/**
 * Servlet hiển thị DANH SÁCH TẤT CẢ phiên đấu giá.
 * Luồng xử lý:
 *   1. Tự động sync trạng thái phiên theo giờ hiện tại
 *   2. Lấy danh sách tất cả phiên
 *   3. Truyền vào JSP hiển thị
 */
@WebServlet(name = "admin-auction-list", value = "/admin-auction-list")
public class AdminAuctionListController extends HttpServlet {

    @Inject
    IAuctionService auctionService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        // Bước 1: Đồng bộ status theo thời gian thực (WAITING->ACTIVE->FINISHED)
        auctionService.syncAuctionStatus();

        // Bước 2: Lấy danh sách tất cả phiên
        List<AuctionModel> listAuction = auctionService.getAllAuctions();

        // Bước 3: Đếm theo từng trạng thái để hiển thị thống kê nhanh
        int[] counts = auctionService.countByStatus();
        // counts[0]=WAITING, [1]=ACTIVE, [2]=FINISHED, [3]=PAID

        // Bước 4: Đặt attribute và forward sang JSP
        request.setAttribute("title", "Quản Lý Đấu Giá");   // Dùng để active aside menu
        request.setAttribute("listAuction", listAuction);
        request.setAttribute("countWaiting",  counts[0]);
        request.setAttribute("countActive",   counts[1]);
        request.setAttribute("countFinished", counts[2]);
        request.setAttribute("countPaid",     counts[3]);

        // Nhận message từ redirect (thêm/sửa/xóa thành công)
        String message = request.getParameter("message");
        String alert   = request.getParameter("alert");
        if (message != null && alert != null) {
            request.setAttribute("message", message);
            request.setAttribute("alert", alert);
        }

        request.getRequestDispatcher("views/admin/auction-list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không dùng POST ở trang danh sách
        doGet(request, response);
    }
}
