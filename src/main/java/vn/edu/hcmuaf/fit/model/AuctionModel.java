package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class AuctionModel {

    private int id;

    private int bookId;

    private double startPrice;

    private double currentPrice;

    private double minIncrement;

    private Timestamp startTime;

    private Timestamp endTime;

    private Integer winnerId;

    private String status;

    private Timestamp createdAt;

    // Thông tin sách
    private Product product;

    // Thông tin người thắng (tùy chọn)
    private CustomerModel winner;

    // Tuấn làm
    private String bookName;       // JOIN từ bảng book
    private String bookImage;      // JOIN từ bảng image_book
    private String winnerName;     // JOIN từ bảng customer
    private String winnerEmail;    // JOIN từ bảng customer
    private int totalBids;         // COUNT từ bảng auction_bids

    public AuctionModel() {
    }

    public AuctionModel(int id, int bookId, double startPrice, double currentPrice,
                        double minIncrement, Timestamp startTime,
                        Timestamp endTime, Integer winnerId,
                        String status, Timestamp createdAt) {
        this.id = id;
        this.bookId = bookId;
        this.startPrice = startPrice;
        this.currentPrice = currentPrice;
        this.minIncrement = minIncrement;
        this.startTime = startTime;
        this.endTime = endTime;
        this.winnerId = winnerId;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public double getStartPrice() {
        return startPrice;
    }

    public void setStartPrice(double startPrice) {
        this.startPrice = startPrice;
    }

    public double getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(double currentPrice) {
        this.currentPrice = currentPrice;
    }

    public double getMinIncrement() {
        return minIncrement;
    }

    public void setMinIncrement(double minIncrement) {
        this.minIncrement = minIncrement;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public Integer getWinnerId() {
        return winnerId;
    }

    public void setWinnerId(Integer winnerId) {
        this.winnerId = winnerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public CustomerModel getWinner() {
        return winner;
    }

    public void setWinner(CustomerModel winner) {
        this.winner = winner;
    }


    // Tuấn làm

    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }

    public String getBookImage() { return bookImage; }
    public void setBookImage(String bookImage) { this.bookImage = bookImage; }

    public String getWinnerName() { return winnerName; }
    public void setWinnerName(String winnerName) { this.winnerName = winnerName; }

    public String getWinnerEmail() { return winnerEmail; }
    public void setWinnerEmail(String winnerEmail) { this.winnerEmail = winnerEmail; }

    public int getTotalBids() { return totalBids; }
    public void setTotalBids(int totalBids) { this.totalBids = totalBids; }

    // Hiển thị trạng thái đấu giá
    public String getStatusLabel() {
        switch (status) {
            case "WAITING":  return "Sắp diễn ra";
            case "ACTIVE":   return "Đang diễn ra";
            case "FINISHED": return "Đã kết thúc";
            case "PAID":     return "Đã thanh toán";
            default:         return status;
        }
    }

    // Css cho từng trạng thái
    public String getStatusBadge() {
        switch (status) {
            case "WAITING":  return "badge-warning";
            case "ACTIVE":   return "badge-success";
            case "FINISHED": return "badge-secondary";
            case "PAID":     return "badge-primary";
            default:         return "badge-light";
        }
    }

}