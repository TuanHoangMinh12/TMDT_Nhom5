package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;
import vn.edu.hcmuaf.fit.services.impl.AuctionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/auction",
        "/auction-detail",
        "/auction-bid"
})
public class AuctionController extends HttpServlet {

    private final IAuctionService auctionService = new AuctionService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getServletPath();

        switch (uri){

            case "/auction":

                List<AuctionModel> list =
                        auctionService.getAllAuction();

                request.setAttribute("listAuction", list);

                request.getRequestDispatcher("/views/web/auction.jsp")
                        .forward(request,response);

                break;

            case "/auction-detail":

                int id = Integer.parseInt(request.getParameter("id"));

                AuctionModel auction = auctionService.getAuctionById(id);

                request.setAttribute("auction", auction);

                request.setAttribute(
                        "bidHistory",
                        auctionService.getBidHistory(id)
                );

                request.getRequestDispatcher("/views/web/auctionDetail.jsp")
                        .forward(request, response);

                break;
        }

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getServletPath();

        if(uri.equals("/auction-bid")){

            CustomerModel user =
                    (CustomerModel) request.getSession()
                            .getAttribute("USERMODEL");

            if(user==null){
                response.sendRedirect(request.getContextPath()+"/login?action=login");
                return;
            }

            int auctionId =
                    Integer.parseInt(request.getParameter("auctionId"));

            double price =
                    Double.parseDouble(request.getParameter("price"));

            String result =
                    auctionService.bid(
                            auctionId,
                            user.getIdUser(),
                            price
                    );

            response.sendRedirect(
                    request.getContextPath()
                            +"/auction-detail?id="
                            +auctionId
                            +"&message="+result
            );
        }

    }

}