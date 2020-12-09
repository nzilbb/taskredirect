<%@ page import = "nz.net.fromont.hexagon.*" 
%><%@ page import = "java.sql.*" 
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
   { // task_id set
      PreparedStatement sqlTask = pg.prepareStatement(
	 "SELECT * FROM " + module + "_task_definition WHERE task_id = ?");
      sqlTask.setString(1, request.getParameter("task_id"));
      ResultSet rsTask = sqlTask.executeQuery();
      if (!rsTask.next())
      {
	 pg.addError("Invalid task");
      }
      else
      {
	 pg.set("task", Page.HashtableFromResultSet(rsTask));      
	 pg.setTitle(rsTask.getString("name"));
	 
	 PreparedStatement sqlFields = pg.prepareStatement(
	    "SELECT * FROM " + module + "_task_field WHERE task_id = ? ORDER BY name");
	 sqlFields.setString(1, request.getParameter("task_id"));
	 ResultSet rsFields = sqlFields.executeQuery();
	 pg.set("fields", Page.HashtableCollectionFromResultSet(rsFields));
	 rsFields.close();
	 sqlFields.close();
      }
      rsTask.close();
      sqlTask.close();
      pg.addHeaderScript("clientid");
   } // task_id set
}
%>
