package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị THỐNG KÊ DOANH THU đấu giá.
 * URL: /admin-auction-stats
 *
 * Bao gồm:
 *  - Tổng doanh thu từ phiên PAID
 *  - Đếm phiên theo trạng thái
 *  - Danh sách phiên đã thanh toán
 */
@WebServlet(name = "admin-auction-stats", value = "/admin-auction-stats")
public class AdminAuctionStatsController extends HttpServlet {

    private AuctionDAO auctionDAO = new AuctionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        // Sync status trước
        auctionDAO.syncAuctionStatus();

        // Lấy dữ liệu thống kê
        double totalRevenue   = auctionDAO.getTotalRevenue();
        int[]  countByStatus  = auctionDAO.countByStatus();
        // Danh sách phiên
        List<AuctionModel> allAuctions = auctionDAO.getAllAuctions();

        request.setAttribute("title",           "Thống Kê Đấu Giá");
        request.setAttribute("totalRevenue",    totalRevenue);
        request.setAttribute("countWaiting",    countByStatus[0]);
        request.setAttribute("countActive",     countByStatus[1]);
        request.setAttribute("countFinished",   countByStatus[2]);
        request.setAttribute("countPaid",       countByStatus[3]);
        request.setAttribute("allAuctions",     allAuctions);

        request.getRequestDispatcher("views/admin/auction-stats.jsp")
               .forward(request, response);
    }
}
