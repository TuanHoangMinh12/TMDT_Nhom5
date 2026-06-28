package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.util.List;

public interface IAuctionDAO {

    List<AuctionModel> findAll();

    AuctionModel findById(int id);

    AuctionModel findByBookId(int bookId);

    boolean insert(AuctionModel auction);

    boolean update(AuctionModel auction);
    boolean updateCurrentPrice(int auctionId, double currentPrice, int winnerId);

    // Tuấn làm
    int deleteAuction(int id); // Xóa phiên đấu giá
    int updateStatus(int id, String newStatus);  // Cập nhật STATUS của phiên đấu giá
    boolean finalizeAuction (int auctionId); // Chốt phiên đấu giá
    void syncAuctionStatus();     // TỰ độNG đồng bộ trạng thái phiên dựa theo thời gian thực
    List<AuctionBidModel> getBidsByAuctionId(int auctionId);  // Lấy toàn bộ lịch sử bid của một phiên

}