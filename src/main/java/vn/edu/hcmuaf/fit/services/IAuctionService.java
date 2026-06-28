package vn.edu.hcmuaf.fit.services;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.sql.Timestamp;
import java.util.List;

public interface IAuctionService {

    List<AuctionModel> getAllAuction();

    AuctionModel getAuctionById(int id);

    String bid(int auctionId, int userId, double price);


    // Tuấn làm
     void syncAuctionStatus();

    List<AuctionModel> getAllAuctions();

    int[] countByStatus();

    double getTotalRevenue();

    int createAuction(int bookId, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);

    int updateAuction(int id, double startPrice, double minIncrement, Timestamp startTime, Timestamp endTime);

    int deleteAuction(int id);

    int updateStatus(int id, String newStatus);
    List<AuctionBidModel> getBidsByAuctionId(int auctionId);

}