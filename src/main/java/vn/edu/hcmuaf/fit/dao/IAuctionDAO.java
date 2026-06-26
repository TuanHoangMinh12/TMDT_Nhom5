package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.util.List;

public interface IAuctionDAO {

    boolean createAuction(AuctionModel auction);

    AuctionModel getAuctionById(int id);

    List<AuctionModel> getAllAuction();

    List<AuctionModel> getRunningAuction();

    boolean updateCurrentPrice(int auctionId, double price);

    boolean updateWinner(int auctionId, int winnerId);
}