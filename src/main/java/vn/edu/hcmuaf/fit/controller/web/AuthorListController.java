package vn.edu.hcmuaf.fit.controller.web;

import vn.edu.hcmuaf.fit.model.AuthorModel;
import vn.edu.hcmuaf.fit.services.IAuthorService;
import vn.edu.hcmuaf.fit.services.impl.AuthorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AuthorListController", urlPatterns = {"/authors"})
public class AuthorListController extends HttpServlet {

    private final IAuthorService authorService = new AuthorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<AuthorModel> listAuthor = authorService.findAll();

        request.setAttribute("listAuthor", listAuthor);

        request.getRequestDispatcher("/views/web/authors.jsp").forward(request, response);
    }
}