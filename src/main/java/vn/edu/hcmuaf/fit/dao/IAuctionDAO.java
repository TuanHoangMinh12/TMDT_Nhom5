package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.util.List;

public interface IAuctionDAO {

    List<AuctionModel> findAll();

    AuctionModel findById(int id);

    AuctionModel findByBookId(int bookId);



    boolean insert(AuctionModel auction);

    boolean update(AuctionModel auction);

    boolean delete(int id);

    boolean updateCurrentPrice(int auctionId, double currentPrice, int winnerId);
}