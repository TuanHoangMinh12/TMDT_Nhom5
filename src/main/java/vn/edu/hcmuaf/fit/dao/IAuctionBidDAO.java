package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;

import java.util.List;

public interface IAuctionBidDAO {

    boolean insertBid(AuctionBidModel bid);

    List<AuctionBidModel> findByAuctionId(int auctionId);

    AuctionBidModel findHighestBid(int auctionId);

    List<AuctionBidModel> findByUserId(int userId);

    // Tuấn làm
    List<AuctionBidModel> getBidsByAuctionId(int auctionId);
    List<AuctionBidModel> getBidsByUserId(int userId);
    int countBidByUserInAuction(int userId, int auctionId);
    List<Integer> getParticipantIds(int auctionId);


}