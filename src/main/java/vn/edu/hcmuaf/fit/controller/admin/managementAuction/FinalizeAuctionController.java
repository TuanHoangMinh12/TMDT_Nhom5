package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.dao.impl.ContactDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/finalize-auction")
public class FinalizeAuctionController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String auctionId = request.getParameter("auctionId");

//        // 1. Tìm người đặt tiền cao nhất từ DB
//        BidDAO bidDAO = new BidDAO();
//        BidModel winner = bidDAO.getHighestBidder(auctionId);
//
//        if (winner != null) {
//            // 2. Cập nhật trạng thái phiên thành FINISHED
//            AuctionDAO auctionDAO = new AuctionDAO();
//            auctionDAO.updateStatus(auctionId, "FINISHED");
//
//            // 3. Lưu kết quả vào bảng Winners (để quản lý giao dịch)
//            auctionDAO.saveWinner(auctionId, winner.getUserId(), winner.getAmount());
//
//            response.getWriter().write("success");
//        } else {
//            response.getWriter().write("no_bidder"); // Phiên không có ai tham gia
//        }
    }
}
