<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
<c:set var="currentPath" value="${requestScope['jakarta.servlet.forward.request_uri']}"/>
<nav class="site-nav">
    <a href="${pageContext.request.contextPath}/analysis" class="nav-item <c:if test="${currentPath.contains('/analysis')}">active</c:if>">업체별 입·출고 분석</a>
    <a href="${pageContext.request.contextPath}/omsNotification" class="nav-item <c:if test="${currentPath.contains('/omsNotification')}">active</c:if>">OMS 전송 이력</a>
    <a href="${pageContext.request.contextPath}/batchLog" class="nav-item <c:if test="${currentPath.contains('/batchLog')}">active</c:if>">배치 실행 이력</a>
</nav>