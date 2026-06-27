package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/auction/detail")
public class AuctionDetailController extends HttpServlet {

    private IAuctionService auctionService = new AuctionService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if(id != null){

            int auctionId = Integer.parseInt(id);

            request.setAttribute("auction",
                    auctionService.findAuctionById(auctionId));

            request.setAttribute("bidHistory",
                    auctionService.getBidHistory(auctionId));

        }
        String message =
                (String) request.getSession().getAttribute("message");

        if(message != null){
            request.setAttribute("message", message);
            request.getSession().removeAttribute("message");
        }
        request.getRequestDispatcher("/views/web/auction_detail.jsp")
                .forward(request,response);

    }
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("===== AuctionBidController Loaded =====");
    }
}