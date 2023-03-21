[OpenNMS][]
===========

[OpenNMS][] is the world's first enterprise grade network management application platform developed under the open source model.

Well, what does that mean?

*	World's First

	The OpenNMS Project was started in July of 1999 and registered on SourceForge in March of 2000. It has years of experience on the alternatives.

*	Enterprise Grade

	It was designed from "day one" to monitor tens of thousands to ultimately unlimited devices with a single instance. It brings the power, scalability and flexibility that enterprises and carriers demand.

*	Application Platform

	While OpenNMS is useful "out of the box," it is designed to be highly customizable to create an unique and integrated management solution.

* Open Source

	OpenNMS is 100% Free and Open Source software, with no license fees, software subscriptions or special "enterprise" versions.

Installing OpenNMS
==================

For details on installing OpenNMS, please see the install guide: [Installing OpenNMS][].

Building OpenNMS
================

For details on building OpenNMS, please see the wiki page: [Building OpenNMS][].

[OpenNMS]:           http://www.opennms.org/
[Building OpenNMS]:  https://wiki.opennms.org/wiki/Installation:Source
[Installing OpenNMS]:  http://docs.opennms.org/opennms/branches/develop/guide-install/guide-install.html


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Description of Changes pushed on 21-03-2023 by Kevlin  under the commit  "21-03-2023 changes related to Garv EC2 Instance Visulization":-

1. There is an addition of folder named in at path stlnms/opennms-webapp/src/main/webapp/ "garvgraph" under which there is two files "idex.jsp" and "button.css"
2. There is an addition at path  stlnms/core/schema/src/main/liquibase/1.6.0/tables/ "garv_ec2.xml".
3. There is an edit in the file named "changelog.xml" at path stlnms/core/schema/src/main/liquibase/1.6.0/ at last line 


