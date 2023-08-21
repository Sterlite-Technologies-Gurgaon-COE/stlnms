1) Database Name change from "opennms" to "stlnms" :-
    files :-
        pom.xml
        => Find tag - "<install.database.name>",  change it's value from opennms to stlnms. Will create database name of "stlnms" and data will update in that database only.
    (Suggestion:- Drop the database as the name of the database is changed, if continue to use the previous database only then "opennms" database will stay there only, but all working will be from "stlnms" database only.)

2) RFMS Changes :- 
    a) RFMS Pie Chart on Dashboard :- 
        files :- 
            opennms-webapp/src/main/webapp/rfms/pie.jsp
    b) RFMS Alerts Table:-
        files :-
            opennms-webapp/src/main/webapp/RFMS_Alerts/index.jsp
    c) RFMS Dashboard :-
        files :-
            opennms-webapp/src/main/webapp/rfms/index.jsp
            CSS Files :- opennms-webapp/src/main/webapp/rfms/css/style.css
    d) RFMS Dashboard & RFMS_Alerts in Navbar :-
        files :-
            opennms-webapp/src/main/webapp/WEB-INF/dispatcher-servlet.xml

3) Asset Changes for Configuration CheckBox :-
    files :-
        core/web-assets/src/main/assets/js/apps/onms-assets/config.json (For adding the checkbox of configuration flag)
        opennms-webapp/src/main/webapp/asset/modify.jsp
        opennms-webapp/src/main/webapp/asset/updateDatabase.jsp

4) Node Page changes :-
    files :- 
        opennms-webapp/src/main/webapp/element/node.jsp (Added UI links of "Run a Command","Template List", "ModBus Page")

5) "config_flag" & "config_schedule_time" Addition in Node Liquibase Table :-
    files :-
        core/schema/src/main/liquibase/1.6.0/tables/node.xml

6) Configuration Links Pages thorugh individual node page :-
    a)Tables in Liquibase for Configuration Managemenet, Schedule Task Tables :-
        files :-
            core/schema/src/main/liquibase/1.6.0/tables/configuration_mgmt.xml
            core/schema/src/main/liquibase/1.6.0/tables/schedule_task.xml
            core/schema/src/main/liquibase/1.6.0/changelog.xml

    b) Run a Command (Configuration Comparision Link) :-
        files :-
            opennms-webapp/src/main/webapp/element/configuration_manage.jsp
    c) Template List (Editing and posting the Templates):-
        files :-
            opennms-webapp/src/main/webapp/element/templateList.jsp
    d) CSS & JS files for configuration :-
        files :-
            opennms-webapp/src/main/webapp/element/css/compare_button.css
            opennms-webapp/src/main/webapp/element/css/config_date_dropdown.css
            opennms-webapp/src/main/webapp/element/css/diffview.css
            opennms-webapp/src/main/webapp/element/css/expand_button.css
            opennms-webapp/src/main/webapp/element/css/google_button.css
            opennms-webapp/src/main/webapp/element/css/template_list.css
            opennms-webapp/src/main/webapp/element/css/template_submit_button.css

            opennms-webapp/src/main/webapp/element/js/difflib.js
            opennms-webapp/src/main/webapp/element/js/diffview.js

    e) ModBus Table Link for Node Page :-
        files :-
            opennms-webapp/src/main/webapp/element/modbusTable.jsp

7) Dialogue box of ModBus :-
        core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/views/quick-add-panel-modbus.html

8) Adding ModBus Dialogue Box to diffrent UI pages :-
    a) js file addition for ModBus Dialogue Box :-
        file :-
            core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/scripts/controllers/Node.js
            core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/scripts/controllers/QuickAddNode.js            
            core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/scripts/controllers/QuickAddNodeModal.js
    b) Addition at the nav bar - Quick Add Node button :-
        files :-
            core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/views/quick-add-node-standalone.html
    c) Addition at the Quick add node from the "Home/Admin/Provisioning Requisitions" :-
        files :-
            core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/views/quick-add-node.html
            (NOTE:- Help View for Quick Add Node is removed from here)
    d) Addition at "Add Node" button in the requisition editing (Path :- Home/Admin/Provisioning Requisitions/{your requisition}/Add Node Button) :-
        => Verticle view of Add Node LayOut :-
            files :-
                core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/views/node-panels.html
        => Horizontal view of Add Node LayOut :-
            files :-
                core/web-assets/src/main/assets/js/apps/onms-requisitions/lib/views/node.html

9) Reports changes :-
    a) Company Logo changed :-
        files :-
            opennms-base-assembly/src/main/filtered/etc/report-templates/assets/images/company-logo.png
            opennms-base-assembly/src/main/filtered/etc/report-templates/assets/images/logo_flat.png

        (Note:- I have not deleted the previous logos, it's still there in the folder.)


<!-- Changes pushed on 16th August 2023 -->
1) Servlet for Template of Configuration Management :-
    files :-
        opennms-webapp/src/main/java/org/opennms/web/postgetservice/GetTemplateServlet.java
        opennms-webapp/src/main/java/org/opennms/web/postgetservice/PostTemplateServlet.java
        opennms-webapp/src/main/webapp/WEB-INF/web.xml
        opennms-webapp/src/main/webapp/element/templateList.jsp
        opennms-webapp/src/main/webapp/element/css/template_list.css
        opennms-webapp/src/main/webapp/element/js/beautify.js

2) KSC Report Print Button :-
    files :-
        opennms-webapp/src/main/webapp/WEB-INF/jsp/KSC/customView.jsp

3) Logo Change for Database Reports (Jasper Reports) :-
    files :-
        opennms-base-assembly/src/main/resources/etc/reports/logo.gif