<%@ page import = "java.sql.*"%>
<% 
} catch(Exception e) { 
} finally {
	try{
		if(stmt!=null){
			stmt.close();
		}
	} catch(Exception e) { 
		throw e;
	} finally {
		try{
			if(stmt2!=null){
				stmt2.close();
			}
		} catch(Exception e) { 
			throw e;
		} finally {
			try{
				if(conn!=null){
					conn.close();
				}
			} catch(Exception e) { 
				throw e;
			} finally {
			}
		}
	}
}
%>
