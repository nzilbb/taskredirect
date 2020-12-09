<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"
%>"${resources['Email']}","${resources['Worker ID']}","${resources['Client ID']}","${resources['Started']}"<c:forEach var="field" items="${fields}">,"${field.name}"</c:forEach><c:forEach var="participant" items="${participants}">
"${participant.email}","${participant.worker_id}","${participant.client_id}",${participant.started}<c:forEach var="field" items="${fields}">,"${participant[field.name]}"</c:forEach></c:forEach>
