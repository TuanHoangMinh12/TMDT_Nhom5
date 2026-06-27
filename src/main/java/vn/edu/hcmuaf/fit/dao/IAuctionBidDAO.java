package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;

import java.util.List;

    public interface IAuctionBidDAO {

    boolean insert(AuctionBidModel bid);

    List<AuctionBidModel> findByAuctionId(int auctionId);

    AuctionBidModel getHighestBid(int auctionId);
}