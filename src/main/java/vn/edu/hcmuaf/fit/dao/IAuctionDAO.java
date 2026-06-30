package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.sql.Timestamp;
import java.util.List;

public interface IAuctionDAO {

    List<AuctionModel> findAll();

    AuctionModel findById(int id);

    AuctionModel findByBookId(int bookId);

    int countActiveAuction();

    boolean insert(AuctionModel auction);

    boolean update(AuctionModel auction);

    boolean updateCurrentPrice(int auctionId, double currentPrice, int winnerId);

    void finishExpiredAuction();
    List<AuctionModel> findWinnerAuctions(int userId);
    // Tuấn làm
    List<AuctionModel> getAllAuctions();
    AuctionModel findById2(int id);
    int createAuction(int bookId, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);
    int updateAuction(int id, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);
    int deleteAuction(int id); // Xóa phiên đấu giá
    int updateStatus(int id, String newStatus);  // Cập nhật STATUS của phiên đấu giá
    boolean finalizeAuction(int auctionId); // Chốt phiên đấu giá
    void syncAuctionStatus();     // TỰ độNG đồng bộ trạng thái phiên dựa theo thời gian thực
    public double getTotalRevenue();
    int[] countByStatus();

}
