<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%
{
   Page pg = (Page) request.getAttribute("page");
   nz.net.fromont.hexagon.Module module = pg.getModule();
   String task_id = request.getParameter("task_id");
   pg.set("task_id", task_id, false);
   String field = request.getParameter("field");

   PreparedStatement sql = pg.prepareStatement(
      "SELECT * FROM " + module + "_task_definition WHERE task_id = ?");
   sql.setString(1, task_id);
   ResultSet rs = sql.executeQuery();
   try
   {
      if (!rs.next())
      {
	 pg.addError("Invalid task: " + task_id);
	 return;
      }
      
      Object[] a = { rs.getString("name") };
      pg.setTitle(pg.localize("Participants for task ''{0}''", a));
      pg.addBreadCrumb("Tasks", "tasks");
      pg.addBreadCrumb(rs.getString("name"), "task?task_id="+task_id);
      pg.addBreadCrumb("Participants", "participants?task_id="+task_id);
      pg.addBreadCrumb("CSV", "participants?task_id="+task_id+(field==null?"":"&field="+field)
		       +"&content-type=text/csv");
   }
   finally
   {
      rs.close();
      sql.close();
   }

   if ("delete".equals(request.getParameter("todo")))
   {
      sql = pg.prepareStatement(
	 "DELETE FROM " + module + "_participant WHERE participant_id = ?");
      sql.setString(1, request.getParameter("x"));
      sql.executeUpdate();
      sql.close();

      pg.addMessage("Record deleted");
   }

   // get a list of fields 
   PreparedStatement sqlFields = pg.prepareStatement(
      "SELECT * FROM " + module + "_task_field WHERE task_id = ? ORDER BY name");
   sqlFields.setString(1, task_id);
   ResultSet rsFields = sqlFields.executeQuery();
   Vector fields = pg.HashtableCollectionFromResultSet(rsFields);
   pg.set("fields", fields);
   rsFields.close();
   sqlFields.close();   
   
   sql = pg.prepareStatement(
      "SELECT p.* FROM "+module+"_participant p"
      +(field == null?"":
	" INNER JOIN "+module+"_participant_field f"
	+" ON p.participant_id = f.participant_id AND p.task_id = f.task_id AND f.name = ?")
      +" WHERE p.task_id = ? ORDER BY "+(field == null?"":" f.value,")+" p.participant_id");
   if (field == null)
   {
      sql.setString(1, task_id);
   }
   else
   {
      sql.setString(1, field);
      sql.setString(2, task_id);
   }
   rs = sql.executeQuery();
   Vector participants = pg.HashtableCollectionFromResultSet(rs);
   rs.close();
   sql.close();

   sqlFields = pg.prepareStatement(
      "SELECT name, value FROM " + module + "_participant_field WHERE task_id = ? AND participant_id = ? ORDER BY name");
   sqlFields.setString(1, task_id);
   for (Object p : participants)
   {
      Hashtable participant = (Hashtable)p;
      sqlFields.setString(2, ""+participant.get("participant_id"));
      ResultSet rsField = sqlFields.executeQuery();
      while (rsField.next())
      {
	 participant.put(rsField.getString("name"), rsField.getString("value"));
      } // next value
      rsField.close();
   } // next participant
   sqlFields.close();

   pg.set("participants", participants);
}
%>