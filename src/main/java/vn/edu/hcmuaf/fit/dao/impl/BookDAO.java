package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IBookDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO implements IBookDAO {
    public Product findById(int idBook) {
        String sql = "SELECT b.*, " +
                "(SELECT img.image FROM image_book img WHERE img.id_book = b.id_book LIMIT 1) AS images " +
                "FROM book b WHERE b.id_book = ?";
        try (Connection con = JDBCConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idBook);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setIdBook(rs.getInt("id_book"));
                    p.setName(rs.getString("name"));
                    p.setImage(rs.getString("images"));
                    p.setQuantity(rs.getInt("quantity"));

                    // 1. Lấy giá gốc
                    double price = rs.getDouble("price");
                    p.setPrice(price);

                    // 2. Lấy phần trăm giảm giá từ cột discount_price
                    double discountPercent = 0;
                    try {
                        discountPercent = rs.getDouble("discount_price");
                    } catch (Exception e) {
                        // Nếu lỗi hoặc null thì mặc định không giảm giá
                    }

                    // 3. Quy đổi phần trăm (0. mấy) thành Giá tiền thực tế
                    double finalPrice = price;
                    if (discountPercent > 0 && discountPercent <= 1) {
                        // Trường hợp DB lưu 0.2 (tức là giảm 20%)
                        finalPrice = price - (price * discountPercent);
                    } else if (discountPercent > 1) {
                        // Trường hợp DB lưu 20 (cũng là giảm 20%)
                        finalPrice = price - (price * discountPercent / 100);
                    }

                    // 4. Gán giá tiền CHUẨN vào hệ thống
                    p.setPriceDiscount(finalPrice);

                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }    @Override
    public List<BookModel> listBookPayTop() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book,b.name, a.name, b.price - b.price * b.discount_price AS giagiam\n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book\n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "JOIN v_sl_pay_top ON b.id_book = v_sl_pay_top.id_book\n" +
                "ORDER BY v_sl_pay_top.sl_book DESC\n" +
                "LIMIT 10");


        PreparedStatement statement = null;
        ResultSet resultSet = null;
        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));

                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }

    @Override
    public List<BookModel> listBookPayTopInProduct() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book ,b.name, a.name, b.price - b.price * b.discount_price AS giagiam\n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book\n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "JOIN v_sl_pay_top ON b.id_book = v_sl_pay_top.id_book\n" +
                "ORDER BY v_sl_pay_top.sl_book DESC");


        PreparedStatement statement = null;
        ResultSet resultSet = null;
        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));
                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }

    public String findImageById(int id) {
        List<String> images = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT image FROM image_book WHERE id_book = ?");

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                statement.setInt(1, id);
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    images.add(resultSet.getString(1));
                }
                return images.isEmpty() ? null : images.get(0);
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }
    @Override
    public List<BookModel> listBookNewReissue() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book, b.name, a.name, b.price - b.price * b.discount_price AS giagiam \n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book \n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "WHERE b.isNew = 1\n" +
                "LIMIT 10");


        PreparedStatement statement = null;
        ResultSet resultSet = null;

        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));
                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }

    @Override
    public List<BookModel> listBookNewInProduct() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book, b.name, a.name, b.price - b.price * b.discount_price AS giagiam \n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book \n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "WHERE b.isNew = 1");


        PreparedStatement statement = null;
        ResultSet resultSet = null;

        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));
                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }

    @Override
    public List<BookModel> listBookReissue() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book, b.name, a.name, b.price - b.price * b.discount_price AS giagiam \n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book \n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "WHERE b.isNew = 1 AND b.quantity = 0\n" +
                "LIMIT 10");


        PreparedStatement statement = null;
        ResultSet resultSet = null;
        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));
                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }

    @Override
    public List<BookModel> listBookReissueInProduct() {
        List<BookModel> listBook = new ArrayList<>();
        Connection connection = JDBCConnector.getConnection();
        String sql = new String("SELECT b.id_book, b.name, a.name, b.price - b.price * b.discount_price AS giagiam \n" +
                ", b.price, b.discount_price*100 AS giam, IF(v_rate.`start` is null, 0, v_rate.`start`) AS `start`\n" +
                ", IF(v_comment.sl_comment is null, 0, v_comment.sl_comment) AS sl_comment,b.id_pc,b.id_p\n" +
                "FROM book b LEFT JOIN author a ON b.id_author = a.id_author\n" +
                "LEFT JOIN v_rate ON b.id_book = v_rate.id_book \n" +
                "LEFT JOIN v_comment ON b.id_book = v_comment.id_book\n" +
                "WHERE b.isNew = 0");


        PreparedStatement statement = null;
        ResultSet resultSet = null;
        if(connection != null) {
            try {
                statement = connection.prepareStatement(sql.toString());
                resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    BookModel bookModel = new BookModel();
                    bookModel.setIdBook(resultSet.getInt(1));
                    bookModel.setName(resultSet.getString(2));
                    bookModel.setNameAuthor(resultSet.getString(3));
                    bookModel.setPriceDiscount(resultSet.getDouble(4));
                    bookModel.setPrice(resultSet.getDouble(5));
                    bookModel.setDiscount(resultSet.getInt(6));
                    bookModel.setQuantityStart(resultSet.getInt(7));
                    bookModel.setQuantityComment(resultSet.getInt(8));
                    bookModel.setIdCP(resultSet.getString(9));
                    bookModel.setIdP(resultSet.getString(10));
                    String image = findImageById(resultSet.getInt(1));
                    bookModel.setImage(image);
                    listBook.add(bookModel);
                }

                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                try {
                    if(connection != null) connection.close();
                    if(statement != null) statement.close();
                    if(resultSet != null) resultSet.close();
                } catch (SQLException e) {
                    return null;
                }
            }
        }
        return null;
    }
}
