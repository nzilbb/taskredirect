<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib  prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.security.MessageDigest" 
%><%@ page import = "org.apache.commons.codec.binary.Hex" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   Site site = pg.getSite();
   nz.net.fromont.hexagon.Module module = pg.getModule();
   User user = pg.getUser();
   Connection connection = pg.getConnection();

   pg.setTitle(module.getName());
   if (request.getParameter("task_id") == null)
   { // no task_id
      pg.addError("Invalid task");
   } // no task_id
   else
   {
      if (request.getParameter("signature") == null)
      { // no consent, return to consent page
	 pg.sendRedirect(session.getAttribute("baseUrl")+"/"+module
	  		 +"/consent?task_id="+request.getParameter("task_id"));
      }
      else
      { // task_id and signature set
	 PreparedStatement sqlTask = pg.prepareStatement(
	    "SELECT * FROM " + module + "_task_definition WHERE active = 1 AND task_id = ?");
	 sqlTask.setString(1, request.getParameter("task_id"));
	 ResultSet rsTask = sqlTask.executeQuery();
	 String email = "";
	 String url = "";
	 int maxParticipants = 0;
	 if (!rsTask.next())
	 { // invalid or inactive task, go back to consent page, which will figure out a message
	    pg.sendRedirect(session.getAttribute("baseUrl")+"/"+module
			    +"/consent?task_id="+request.getParameter("task_id"));
	 }
	 else
	 {
	    pg.set("task", Page.HashtableFromResultSet(rsTask));      
	    pg.setTitle(rsTask.getString("name"));
	    email = rsTask.getString("email");
	    url = rsTask.getString("url");
	    maxParticipants = rsTask.getInt("max_participants");
	 }
	 rsTask.close();
	 sqlTask.close();

	 // check they haven't already done the experiment
	 String participantEmail = request.getParameter("signature");
	 PreparedStatement sqlUnique = pg.prepareStatement(
	    "SELECT * FROM " + module + "_participant WHERE task_id = ? AND email = ?");
	 sqlUnique.setString(1, request.getParameter("task_id"));
	 sqlUnique.setString(2, participantEmail);
	 ResultSet rsUnique = sqlUnique.executeQuery();
	 if (rsUnique.next())
	 { // repeat participant
	    pg.set("notunique", Boolean.TRUE);
	 } // repeat participant
	 else
	 { // new participant
	    MessageDigest md5 = MessageDigest.getInstance("MD5");
	    md5.update((participantEmail // workerId is MD5 hash of email address
			+ new java.util.Date().toString()) // with current time as a nonce
		       .getBytes());
	    byte[] hash = md5.digest();
	    String workerId = new String(Hex.encodeHex(hash));
	    // start experiment
	    PreparedStatement sql = pg.prepareStatement(
	       "INSERT INTO " + module + "_participant"
	       + " (worker_id, task_id, signature, email, started, client_id) VALUES (?,?,?,?,Now(),?)");
	    sql.setString(1, workerId);
	    sql.setString(2, request.getParameter("task_id"));
	    sql.setString(3, request.getParameter("signature"));
	    sql.setString(4, participantEmail);
	    sql.setString(5, request.getParameter("client_id"));
	    sql.executeUpdate();
	    sql.close();
	    sql = pg.prepareStatement("SELECT LAST_INSERT_ID()");
	    ResultSet rs = sql.executeQuery();
	    rs.next();
	    long participant_id = rs.getLong(1);
	    rs.close();
	    sql.close();
	    pg.set("participant_id", participant_id);
	    pg.set("task_id", request.getParameter("task_id"));

	    // save fields
	    String fieldDescription = "";
	    sql = pg.prepareStatement(
	       "INSERT INTO " + module + "_participant_field"
	       + " (task_id, participant_id, name, value) VALUES (?,?,?,?)");
	    sql.setString(1, request.getParameter("task_id"));
	    sql.setLong(2, participant_id);
	    PreparedStatement sqlFields = pg.prepareStatement(
	       "SELECT * FROM " + module + "_task_field WHERE task_id = ? ORDER BY name");
	    sqlFields.setString(1, request.getParameter("task_id"));
	    ResultSet rsFields = sqlFields.executeQuery();
	    while (rsFields.next())
	    {
	       String name = rsFields.getString("name");
	       String value = request.getParameter(name);
	       if (value != null)
	       {
		  sql.setString(3, name);
		  sql.setString(4, value);
		  sql.executeUpdate();
		  fieldDescription += "\n" + name + " = " + value;
	       }
	    } // next field
	    sqlFields.close();
	    rsFields.close();
	    sql.close();
	    
	    // send notification
	    if (email != null && email.length() > 0)
	    {
	       try
	       {
		  pg.getSite().sendEmail(email, email, pg.getTitle(), 
					 "A participant has started the task:\n" +workerId
					 +fieldDescription);
	       }
	       catch(Exception exception)
	       {
		  pg.set("mailError", exception.toString());
	       }
	    }

	    if (maxParticipants > 0)
	    {
	       // check number of participants
	       PreparedStatement sqlParticipantCount = pg.prepareStatement(
		  "SELECT COUNT(*) FROM " + module + "_participant WHERE task_id = ?");
	       sqlParticipantCount.setString(1, request.getParameter("task_id"));
	       ResultSet rsParticipantCount = sqlParticipantCount.executeQuery();
	       rsParticipantCount.next();
	       if (rsParticipantCount.getInt(1) >= maxParticipants)
	       { // got all the participants we need
		  sqlTask = pg.prepareStatement(
		     "UPDATE " + module + "_task_definition SET active = 0 WHERE task_id = ?");
		  sqlTask.setString(1, request.getParameter("task_id"));
		  sqlTask.executeUpdate();
		  sqlTask.close();
	       }
	       rsParticipantCount.close();
	       sqlParticipantCount.close();
	    }
	 
	    pg.sendRedirect(url + workerId);
	 } // new participant
	 rsUnique.close();
	 sqlUnique.close();
      } // task_id and signature set
   } // task_id set   
}
%>
