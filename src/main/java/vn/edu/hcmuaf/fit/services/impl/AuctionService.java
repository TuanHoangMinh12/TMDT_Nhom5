package vn.edu.hcmuaf.fit.services.impl;

import vn.edu.hcmuaf.fit.dao.IAuctionBidDAO;
import vn.edu.hcmuaf.fit.dao.IAuctionDAO;
import vn.edu.hcmuaf.fit.dao.IAuctionNotificationDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionBidDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionNotificationDAO;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;

import java.sql.Timestamp;
import java.util.List;

public class AuctionService implements IAuctionService {

    IAuctionDAO auctionDAO = new AuctionDAO();
    IAuctionBidDAO bidDAO = new AuctionBidDAO();
    IAuctionNotificationDAO notificationDAO = new AuctionNotificationDAO();

    @Override
    public List<AuctionModel> getAllAuction() {
        return auctionDAO.findAll();
    }

    @Override
    public AuctionModel getAuctionById(int id) {
        return auctionDAO.findById(id);
    }

    @Override
    public String bid(int auctionId, int userId, double price) {

        AuctionModel auction = auctionDAO.findById(auctionId);

        if (auction == null)
            return "Không tìm thấy phiên đấu giá";

        Timestamp now = new Timestamp(System.currentTimeMillis());

        if (now.before(auction.getStartTime()))
            return "Phiên đấu giá chưa bắt đầu";

        if (now.after(auction.getEndTime()))
            return "Phiên đấu giá đã kết thúc";

        double minPrice =
                auction.getCurrentPrice() + auction.getMinIncrement();

        if (price < minPrice)
            return "Giá phải lớn hơn hoặc bằng " + minPrice;

        AuctionBidModel bid = new AuctionBidModel();

        bid.setAuctionId(auctionId);
        bid.setUserId(userId);
        bid.setBidPrice(price);

        bidDAO.insertBid(bid);

        auctionDAO.updateCurrentPrice(
                auctionId,
                price,
                userId
        );

        return "success";
    }

    @Override
    public AuctionModel findAuctionById(int id) {
        return auctionDAO.findById(id);
    }

    @Override
    public List<AuctionBidModel> getBidHistory(int auctionId) {
        return bidDAO.findByAuctionId(auctionId);
    }
    @Override
    public void finishExpiredAuction() {
        auctionDAO.finishExpiredAuction();
    }
    @Override
    public List<AuctionModel> getWinnerAuctions(int userId) {
        return auctionDAO.findWinnerAuctions(userId);
    }
    // Tuấn làm

    @Override
    public void syncAuctionStatus() {
        auctionDAO.syncAuctionStatus();
    }
    @Override
    public List<AuctionModel> getAllAuctions() {
        return auctionDAO.getAllAuctions();
    }

    @Override
    public AuctionModel findById2(int id) {
        return auctionDAO.findById2(id);
    }

    @Override
    public int[] countByStatus() {
        return auctionDAO.countByStatus();
    }

    @Override
    public double getTotalRevenue() {
        return auctionDAO.getTotalRevenue();
    }

    @Override
    public int createAuction(int bookId, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime) {
        return auctionDAO.createAuction(bookId, startPrice, minIncrement, startTime, endTime);
    }
    @Override
    public int updateAuction(int id, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime) {
        return auctionDAO.updateAuction(id, startPrice, minIncrement, startTime, endTime);
    }
    @Override
    public int countActiveAuction() {
        return auctionDAO.countActiveAuction();
    }
    @Override
    public int deleteAuction(int id) {
        return auctionDAO.deleteAuction(id);
    }

    @Override
    public int updateStatus(int id, String newStatus) {
        return auctionDAO.updateStatus(id, newStatus);
    }

    @Override
    public boolean finalizeAuction(int auctionId) {
        return false;
    }

    // Bọc thêm hàm của BidDAO để Controller gọi được Lịch sử
    @Override
    public List<AuctionBidModel> getBidsByAuctionId(int auctionId) {
        return bidDAO.findByAuctionId(auctionId);
    }

    // Hàm chốt phiên và tự động gửi thông báo cho tất cả những người tham gia
    @Override
    public boolean finalizeAndNotify(int auctionId) {
        // 1. Chốt phiên (Hàm finalizeAuction bạn đã có sẵn bên trong AuctionDAO)
        boolean isFinalized = auctionDAO.finalizeAuction(auctionId);

        if (isFinalized) {
            // 2. Lấy thông tin phiên vừa chốt
            AuctionModel auction = auctionDAO.findById(auctionId);

            if (auction != null && auction.getWinnerId() != null) {
                int winnerId = auction.getWinnerId();
                double finalPrice = auction.getCurrentPrice();
                String bookName = auction.getProduct() != null ? auction.getProduct().getName() : "Sách đấu giá";

                // 3. Lấy danh sách ID người tham gia (Hàm vừa thêm ở Bước 1)
                List<Integer> participants = bidDAO.getParticipantIds(auctionId);

                // 4. Gửi thông báo
                for (int userId : participants) {
                    String title, content;
                    if (userId == winnerId) {
                        title   = "Chúc mừng! Bạn đã thắng phiên đấu giá!";
                        content = "Bạn đã thắng phiên đấu giá cuốn \"" + bookName +
                                "\" với giá " + String.format("%,.0f đ", finalPrice) +
                                ". Admin sẽ liên hệ để xác nhận thanh toán.";
                    } else {
                        title   = "Thông báo kết quả phiên đấu giá";
                        content = "Rất tiếc! Bạn đã không thắng phiên đấu giá cuốn \"" +
                                bookName + "\". Hãy thử lại ở phiên tiếp theo nhé!";
                    }
                    notificationDAO.sendNotification(userId, auctionId, title, content);
                }
            }
            return true;
        }
        return false;
    }

}