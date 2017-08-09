<%@ taglib prefix="input" uri="http://fromont.net.nz/java/taglib/htmlui" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<table id="participants">
  <caption>${resources['Participants:']} ${fn:length(participants)}</caption>
  <thead>
    <tr>
      <th class="email">${resources['Email']}</th>
      <th class="worker_id">${resources['Worker ID']}</th>
      <th class="started">${resources['Started']}</th>
      <c:forEach var="field" items="${fields}">
	<th class="${field.name}"><a title="${resources['Filter']}" href="participants?task_id=${task_id}&field=${field.name}">${field.name}</a></th></c:forEach>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="participant" items="${participants}">
    <tr id="${participant.participant_id}">
      <td class="email">${participant.email}</td>
      <td class="worker_id">${participant.worker_id}</td>
      <td class="started">${participant.started}</td>
      <c:forEach var="field" items="${fields}">
	<td class="${field.name}" title="${field.name}">${participant[field.name]}</td></c:forEach>
      <td class="delete">
	<hex:button text="${resources['Delete']}" 
		    icon="${template_path}/icon/user-trash.png"
		    url="?task_id=${task_id}&todo=delete&x=${participant.participant_id}"/></td>
    </tr></c:forEach>
  </tbody>
</table>
