package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/auction/bid")
public class AuctionBidController extends HttpServlet {

    private final IAuctionService auctionService = new AuctionService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        CustomerModel user =
                (CustomerModel) request.getSession().getAttribute("USERMODEL");

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login?action=login");

            return;
        }

        int auctionId = Integer.parseInt(request.getParameter("auctionId"));

        double price = Double.parseDouble(request.getParameter("price"));

        String result =
                auctionService.bid(
                        auctionId,
                        user.getIdUser(),
                        price
                );

        if ("success".equals(result)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/auction/detail?id="
                            + auctionId);

        } else {

            request.setAttribute("message", result);

            request.setAttribute("auction",
                    auctionService.findAuctionById(auctionId));

            request.setAttribute("bidHistory",
                    auctionService.getBidHistory(auctionId));

            request.getRequestDispatcher(
                            "/views/web/auction_detail.jsp")
                    .forward(request, response);

        }

    }
}