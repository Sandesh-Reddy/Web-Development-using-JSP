<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRM System - Customer Relationship Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<%= basePath %>css/style.css">
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h1>CRM System</h1>
            </div>
            <nav class="nav">
                <a href="<%= basePath %>index.jsp" class="<%= request.getRequestURI().endsWith("index.jsp") ? "active" : "" %>">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="<%= basePath %>pages/customers/list.jsp" class="<%= request.getRequestURI().contains("customers") ? "active" : "" %>">
                    <i class="fas fa-user-friends"></i> Customers
                </a>
                <a href="<%= basePath %>pages/leads/list.jsp" class="<%= request.getRequestURI().contains("leads") ? "active" : "" %>">
                    <i class="fas fa-bullseye"></i> Sales Leads
                </a>
                <a href="<%= basePath %>pages/communications/list.jsp" class="<%= request.getRequestURI().contains("communications") ? "active" : "" %>">
                    <i class="fas fa-comments"></i> Communications
                </a>
                <a href="<%= basePath %>pages/reports/dashboard.jsp" class="<%= request.getRequestURI().contains("reports") ? "active" : "" %>">
                    <i class="fas fa-chart-bar"></i> Reports
                </a>
            </nav>
        </div>
    </div>
    <div class="container fade-in">