package vn.edu.hcmuaf.fit.services;

import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.util.List;

public interface IAuctionService {

    List<AuctionModel> getAllAuction();

    AuctionModel getAuctionById(int id);

    String bid(int auctionId, int userId, double price);

    AuctionModel findAuctionById(int id);

    List<AuctionBidModel> getBidHistory(int auctionId);

}