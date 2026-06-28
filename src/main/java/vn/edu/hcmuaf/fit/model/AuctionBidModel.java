package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class AuctionBidModel {

    private int id;

    // id phiên đấu giá
    private int auctionId;

    // id người đấu giá
    private int userId;

    // số tiền đặt
    private double bidPrice;

    // thời gian đặt
    private Timestamp bidTime;

    // Hiển thị thông tin người đặt
    private CustomerModel customer;

    // Tuấn làm
    private String userName;
    private String userEmail;   // Dùng để phát hiện spam

    public AuctionBidModel() {
    }

    public AuctionBidModel(int auctionId, int userId, double bidPrice) {
        this.auctionId = auctionId;
        this.userId = userId;
        this.bidPrice = bidPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getBidPrice() {
        return bidPrice;
    }

    public void setBidPrice(double bidPrice) {
        this.bidPrice = bidPrice;
    }

    public Timestamp getBidTime() {
        return bidTime;
    }

    public void setBidTime(Timestamp bidTime) {
        this.bidTime = bidTime;
    }

    public CustomerModel getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerModel customer) {
        this.customer = customer;
    }

    // Tuấn làm
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    @Override
    public String toString() {
        return "AuctionBidModel{" +
                "id=" + id +
                ", auctionId=" + auctionId +
                ", userId=" + userId +
                ", bidPrice=" + bidPrice +
                ", bidTime=" + bidTime +
                '}';
    }
}