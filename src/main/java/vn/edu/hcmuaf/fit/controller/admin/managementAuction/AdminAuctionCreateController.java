package vn.edu.hcmuaf.fit.controller.admin.managementAuction;

import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.dao.impl.BookManagementDAO;
import vn.edu.hcmuaf.fit.model.BookManagementModel;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;
import vn.edu.hcmuaf.fit.services.impl.BookManagementService;
import vn.edu.hcmuaf.fit.utils.MessageParameterUntil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Servlet xử lý THÊM MỚI phiên đấu giá.
 * GET  -> Hiển thị form tạo mới (kèm danh sách sách để chọn)
 * POST -> Nhận dữ liệu form, lưu vào DB, redirect về danh sách
 */
@WebServlet(name = "admin-auction-create", value = "/admin-auction-create")
public class AdminAuctionCreateController extends HttpServlet {

    private AuctionService auctionService = new AuctionService();
    private BookManagementService bookManagementService = new BookManagementService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        // Lấy danh sách sách để đưa vào dropdown chọn sách
        List<BookManagementModel> listBook = bookManagementService.findAll();

        request.setAttribute("title", "Quản Lý Đấu Giá");
        request.setAttribute("listBook", listBook);

        request.getRequestDispatcher("views/admin/auction-form.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");

        try {
            // Lấy dữ liệu từ form
            int    bookId       = Integer.parseInt(request.getParameter("bookId"));
            double startPrice   = Double.parseDouble(request.getParameter("startPrice"));
            double minIncrement = Double.parseDouble(request.getParameter("minIncrement"));
            String startTimeStr = request.getParameter("startTime");  // "yyyy-MM-ddTHH:mm"
            String endTimeStr   = request.getParameter("endTime");

            // Validate: giá khởi điểm phải > 0
            if (startPrice <= 0 || minIncrement <= 0) {
                List<BookManagementModel> listBook = bookManagementService.findAll();
                request.setAttribute("listBook", listBook);
                new MessageParameterUntil(
                    "Giá khởi điểm và bước giá phải lớn hơn 0!", "danger",
                    "views/admin/auction-form.jsp", request, response
                ).send();
                return;
            }

            // Chuyển chuỗi datetime từ form sang Timestamp
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp startTime = new Timestamp(sdf.parse(startTimeStr).getTime());
            Timestamp endTime   = new Timestamp(sdf.parse(endTimeStr).getTime());

            // Validate: thời gian kết thúc phải sau thời gian bắt đầu
            if (!endTime.after(startTime)) {
                List<BookManagementModel> listBook = bookManagementService.findAll();
                request.setAttribute("listBook", listBook);
                new MessageParameterUntil(
                    "Thời gian kết thúc phải sau thời gian bắt đầu!", "danger",
                    "views/admin/auction-form.jsp", request, response
                ).send();
                return;
            }

            // Lưu vào DB
            int result = auctionService.createAuction(bookId, startPrice, minIncrement, startTime, endTime);

            if (result > 0) {
                // Thành công -> redirect về danh sách với thông báo
                response.sendRedirect(request.getContextPath() +
                    "/admin-auction-list?message=Tạo phiên đấu giá thành công!&alert=success");
            } else {
                List<BookManagementModel> listBook = bookManagementService.findAll();
                request.setAttribute("listBook", listBook);
                new MessageParameterUntil(
                    "Tạo phiên thất bại! Vui lòng thử lại.", "danger",
                    "views/admin/auction-form.jsp", request, response
                ).send();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/admin-auction-list?message=Có lỗi xảy ra: " + e.getMessage() + "&alert=danger");
        }
    }
}
