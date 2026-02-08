<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
<c:set var="currentPath" value="${requestScope['jakarta.servlet.forward.request_uri']}"/>
<nav class="site-nav">
    <a href="${pageContext.request.contextPath}/analysis" class="nav-item <c:if test="${currentPath.contains('/analysis')}">active</c:if>">업체별 입·출고 분석</a>
    <a href="${pageContext.request.contextPath}/oms-history" class="nav-item <c:if test="${currentPath.contains('/oms-history')}">active</c:if>">OMS 전송 이력</a>
    <a href="${pageContext.request.contextPath}/report" class="nav-item <c:if test="${currentPath.contains('/report')}">active</c:if>">운영 보고서</a>
</nav>