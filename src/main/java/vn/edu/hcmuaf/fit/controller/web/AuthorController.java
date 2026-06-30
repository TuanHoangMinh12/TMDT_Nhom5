package vn.edu.hcmuaf.fit.controller.web;

import vn.edu.hcmuaf.fit.model.AuthorModel;
import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.services.IAuthorService;
import vn.edu.hcmuaf.fit.services.IProductService;
import vn.edu.hcmuaf.fit.services.impl.AuthorService;
import vn.edu.hcmuaf.fit.services.impl.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AuthorController", urlPatterns = {"/author"})
public class AuthorController extends HttpServlet {

    private final IAuthorService authorService = new AuthorService();
    private final IProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int idAuthor;
        try {
            idAuthor = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        AuthorModel authorModel = authorService.findById(idAuthor);

        if (authorModel == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<BookModel> listBookOfAuthor = productService.find12BookAuthor(idAuthor);

        List<String> listInformation = new ArrayList<>();
        if (authorModel.getInformation() != null) {
            String[] parts = authorModel.getInformation().split("\n");
            for (String part : parts) {
                if (!part.trim().isEmpty()) {
                    listInformation.add(part.trim());
                }
            }
        }

        request.setAttribute("authorModel", authorModel);
        request.setAttribute("listBookOfAuthor", listBookOfAuthor);
        request.setAttribute("listInformation", listInformation);

        request.getRequestDispatcher("/views/web/author.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}