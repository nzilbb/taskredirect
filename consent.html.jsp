<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<h1>${page.title}</h1>

<c:if test="${!empty task}">
  
  <c:if test="${task.active eq 1}">
    <div id="consent">${task.consent}</div>
    <form id="consentform" action="start" method="post" onpost="return consent();">
      <c:forEach var="field" items="${fields}">
	<div class="field" id="${field.name}">
	  <input type="checkbox" name="${field.name}" value="true" /><span class="description">${field.description}</span>
      </div></c:forEach>
      <div class="signature">
	<input type="hidden" name="task_id" value="${task.task_id}"/>
	<input type="email" name="signature" class="signature" placeholder="${resources['Email Address']}" autofocus required />
      </div>
      <div class="consentbutton">
	<hex:submitbutton text="${resources['Start']}" 
			  title="${resources['Start the task now']}"
			  icon="${template_path}/icon/go-next.png"/>
      </div>
    </form>
    <script type="text/javascript">//<![CDATA[
// get consent
function consent() {
  var frm = document.getElementById("consentform");
  if (frm.signature.value.trim() == "") {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
<c:if test="${!empty task.valid_signature_pattern}">
  } else if (!new RegExp("${task.valid_signature_pattern}").test(frm.signature.value)) {
    alert("${resources['Please fill in the box to indicate your consent.']}");
    frm.signature.focus();
    return false;
</c:if>
  }
  return true;
}
//]]></script>
  </c:if>

  <c:if test="${task.active ne 1}">
    <div id="consent">${task.inactive_message}</div>
  </c:if>
  
</c:if>
