package vn.edu.hcmuaf.fit.services;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.sql.Timestamp;
import java.util.List;

public interface IAuctionService {

    List<AuctionModel> getAllAuction();

    AuctionModel getAuctionById(int id);

    String bid(int auctionId, int userId, double price);


    AuctionModel findAuctionById(int id);

    List<AuctionBidModel> getBidHistory(int auctionId);

    void finishExpiredAuction();
    List<AuctionModel> getWinnerAuctions(int userId);
    // Tuấn làm
    List<AuctionModel> getAllAuctions();

    AuctionModel findById2(int id);

    int createAuction(int bookId, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);

    int updateAuction(int id, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);

    int deleteAuction(int id); // Xóa phiên đấu giá

    int updateStatus(int id, String newStatus);  // Cập nhật STAđTUS của phiên ấu giá

    boolean finalizeAuction(int auctionId); // Chốt phiên đấu giá

    void syncAuctionStatus();     // TỰ độNG đồng bộ trạng thái phiên dựa theo thời gian thực

    double getTotalRevenue();

    int[] countByStatus();

    List<AuctionBidModel> getBidsByAuctionId(int auctionId);

    boolean finalizeAndNotify(int auctionId);
}



